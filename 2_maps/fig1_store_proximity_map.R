#===============================================================================
# fig1_store_proximity_map.R
# VAT exemption pass-through and incidence (Papua New Guinea)
#
# PURPOSE : Produce Figure 1, the Port Moresby supermarket store-proximity map
#           (tertile classification), and add proximity_tertile to the price data.
# INPUTS  : data/raw/store_collection/POM PRICE COLLECTION.xlsx (gps_coordinates);
#           Final store price data POM_Prices_Long_Clean.csv
# OUTPUTS : figure_1.png (dir_figures);
#           POM_Prices_Long_Clean.csv / .dta updated with proximity_tertile
# DEPENDS : run after main.do data prep (POM_Prices_Long_Clean built upstream)
# CALLED BY: main.R
#
# Contents:
#   1) GPS EXTRACTION    : extract supermarket coordinates
#   2) PROXIMITY ANALYSIS: compute intensity and tertile classification
#   3) MAP               : tertile proximity map (Figure 1)
#   4) MERGE TO DATASET  : add tertile classification to price data
#
#  Produces one map only (Figure 1, POM_Proximity_Tertile). The plain location
#  map and the binary-classification map were removed: neither is a paper
#  exhibit, and the binary classification fed no downstream script. The store
#  event study (Figure 4a) and the pass-through distribution (Figure 4b/A37)
#  both use proximity_tertile only.
#===============================================================================

# 1: GPS Extraction ----

{
  cat("\n=== PART 1: GPS EXTRACTION ===\n")
  
  # Set file path
  file_path <- file.path(dir_data_raw_store, "POM PRICE COLLECTION.xlsx")
  
  # Check file exists
  if (!file.exists(file_path)) {
    stop(
      "Excel file not found: ",
      file_path,
      "\nPlease ensure 'POM PRICE COLLECTION.xlsx' is in data/raw/store_collection/"
    )
  }
  
  # Load GPS coordinates from gps_coordinates sheet
  gps_data <- read_excel(
    file_path,
    sheet = "gps_coordinates",
    col_types = "text",
    col_names = TRUE,
    .name_repair = "minimal"
  )
  
  # Clean GPS data
  supermarket_locations <- gps_data %>%
    filter(!is.na(lat) & !is.na(lng)) %>%
    filter(lat < 0 & lat > -15 & lng > 140 & lng < 160) %>%
    mutate(
      lat = as.numeric(lat),
      lng = as.numeric(lng)
    ) %>%
    select(Name, Suburb, lat, lng) %>%
    rename(Supermarket = Name)
  
  cat(
    "Found",
    nrow(supermarket_locations),
    "supermarkets with GPS coordinates\n"
  )
}

# 2: Proximity Analysis ----

{
  cat("\n=== PART 2: PROXIMITY ANALYSIS ===\n")
  
  # Analysis parameters
  speed_kmh <- 20 # average city driving speed
  t_half_min <- 5 # half-life in minutes
  T_max_min <- 25 # max travel time considered
  
  v_mpm <- (speed_kmh * 1000) / 60
  rho <- log(2) / t_half_min
  
  cat(
    "Parameters: speed =",
    speed_kmh,
    "km/h, half-life =",
    t_half_min,
    "min\n"
  )
  
  # Convert to data.table
  DT <- as.data.table(supermarket_locations)
  stores <- DT[!is.na(lat) & !is.na(lng)]
  stores[, id := .I]
  setcolorder(stores, c("id", "Supermarket", "Suburb", "lng", "lat"))
  
  cat("Analyzing", nrow(stores), "supermarkets\n")
  
  if (nrow(stores) >= 2) {
    # Calculate pairwise distances
    coords <- as.matrix(stores[, .(lng, lat)])
    coords <- apply(coords, 2, as.numeric)
    
    d_m <- geosphere::distm(coords, fun = geosphere::distHaversine)
    tau_min <- d_m / v_mpm
    diag(tau_min) <- NA_real_
    
    # Apply distance cap
    tau_min_cap <- tau_min
    tau_min_cap[tau_min_cap > T_max_min] <- NA_real_
    
    # Calculate intensity
    W <- exp(-rho * tau_min_cap)
    W[is.na(W)] <- 0
    intensity <- rowSums(W, na.rm = TRUE)
    
    # Tertile classification
    qs <- quantile(intensity, probs = c(1 / 3, 2 / 3), na.rm = TRUE)
    class_tertile <- fifelse(
      intensity <= qs[1],
      "Low",
      fifelse(intensity <= qs[2], "Medium", "High")
    )
    
    med_intensity <- median(intensity, na.rm = TRUE)
    class_binary <- fifelse(intensity > med_intensity, "Above Median", "Below Median")
    
    # Create results
    supermarket_data <- stores[, .(
      id,
      Name = Supermarket,
      suburb = Suburb,
      lon = lng,
      lat
    )][, `:=`(
      intensity = intensity,
      proximity_tertile = factor(
        class_tertile,
        levels = c("Low", "Medium", "High")
      ),
      proximity_binary = factor(
        class_binary,
        levels = c("Below Median", "Above Median")
      )
    )]
    
    cat("\nTertile Classification:\n")
    print(table(supermarket_data$proximity_tertile))
  } else {
    supermarket_data <- stores
    supermarket_data$intensity <- NA
    supermarket_data$proximity_tertile <- NA
    supermarket_data$proximity_binary <- NA
  }
}

# 3: Create Map (Figure 1) ----

{
  cat("\n=== PART 3: CREATING TERTILE MAP ===\n")
  
  if (
    exists("supermarket_data") &&
    nrow(supermarket_data) > 0 &&
    !all(is.na(supermarket_data$lat))
  ) {
    # Calculate map bounds
    coords_matrix <- as.matrix(supermarket_data[, .(lon, lat)])
    coords_matrix <- apply(coords_matrix, 2, as.numeric)
    
    lat_min <- min(coords_matrix[, 2], na.rm = TRUE)
    lat_max <- max(coords_matrix[, 2], na.rm = TRUE)
    lng_min <- min(coords_matrix[, 1], na.rm = TRUE)
    lng_max <- max(coords_matrix[, 1], na.rm = TRUE)
    
    lat_pad <- (lat_max - lat_min) * 0.08
    lng_pad <- (lng_max - lng_min) * 0.08
    
    # Basemap via raster tiles fetched with maptiles, drawn with tidyterra.
    # maptiles uses CARTO / OSM tile servers and takes an explicit bounding box.
    # Tiles cache to disk, so reruns and replication do not re-download.
    cat("Preparing raster-tile basemap (CARTO via maptiles)...\n")
    for (pkg in c("maptiles", "tidyterra")) {
      if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
    }
    tile_cache <- file.path(dir_data_raw_store, "tile_cache")
    dir.create(tile_cache, showWarnings = FALSE, recursive = TRUE)
    
    bb_sf <- sf::st_as_sfc(sf::st_bbox(c(
      xmin = lng_min - lng_pad, ymin = lat_min - lat_pad,
      xmax = lng_max + lng_pad, ymax = lat_max + lat_pad
    ), crs = 4326))
    
    basetile <- tryCatch(
      maptiles::get_tiles(
        bb_sf,
        provider = "CartoDB.Positron",  # alternatives: "OpenStreetMap", "CartoDB.DarkMatter"
        zoom     = 13,                  # 14 = more detail, 12 = wider context
        crop     = TRUE,
        cachedir = tile_cache
      ),
      error = function(e) {
        cat("  Tile fetch failed, rendering points only:", conditionMessage(e), "\n")
        NULL
      }
    )
    
    # base layer added to the map below. If tiles are unavailable, base_tiles is
    # NULL and ggplot ignores it (points render on a blank background).
    if (is.null(basetile)) {
      base_tiles <- NULL
    } else {
      base_tiles <- tidyterra::geom_spatraster_rgb(data = basetile, maxcell = 5e6)
    }
    
    # OSM vector layers disabled: empty objects so the "if (!is.null(...))" guard
    # blocks in the map skip cleanly. The tile basemap replaces them.
    empty_osm     <- osmdata::osmdata()
    roads_primary <- empty_osm
    roads_other   <- empty_osm
    water         <- empty_osm
    rivers        <- empty_osm
    landuse       <- empty_osm
    parks         <- empty_osm
    coast         <- empty_osm
    coastline     <- NULL
    
    # Tertile classification map (Figure 1)
    if (!all(is.na(supermarket_data$proximity_tertile))) {
      cat("Creating tertile proximity map...\n")
      
      results_sf_tertile <- st_as_sf(
        supermarket_data[!is.na(proximity_tertile)],
        coords = c("lon", "lat"),
        crs = 4326
      )
      
      tertile_map <- ggplot() +
        base_tiles +
        # Green areas
        {
          if (!is.null(landuse$osm_polygons))
            geom_sf(
              data = landuse$osm_polygons,
              fill = "#a6d96a",
              color = NA,
              alpha = 0.5
            )
        } +
        {
          if (!is.null(parks$osm_polygons))
            geom_sf(
              data = parks$osm_polygons,
              fill = "#a6d96a",
              color = NA,
              alpha = 0.5
            )
        } +
        # Water bodies
        {
          if (!is.null(water$osm_polygons))
            geom_sf(
              data = water$osm_polygons,
              fill = "#4575b4",
              color = NA,
              alpha = 0.5
            )
        } +
        # Rivers
        {
          if (!is.null(rivers$osm_lines))
            geom_sf(
              data = rivers$osm_lines,
              color = "#4575b4",
              linewidth = 0.4,
              alpha = 0.5
            )
        } +
        # Minor roads
        {
          if (!is.null(roads_other$osm_lines))
            geom_sf(
              data = roads_other$osm_lines,
              color = "gray80",
              linewidth = 0.3,
              alpha = 0.5
            )
        } +
        # Primary roads - more prominent
        {
          if (!is.null(roads_primary$osm_lines))
            geom_sf(
              data = roads_primary$osm_lines,
              color = "gray40",
              linewidth = 0.5,
              alpha = 0.5
            )
        } +
        # Coastline
        {
          if (!is.null(coastline) && nrow(coastline) > 0)
            geom_sf(
              data = coastline,
              color = "black",
              linewidth = 0.2,
              alpha = 1
            )
        } +
        # Supermarkets with tertile classification
        geom_sf(
          data = results_sf_tertile,
          aes(color = proximity_tertile),
          size = 2.5,
          alpha = 0.9,
          stroke = 1,
          shape = 21,
          fill = "white"
        ) +
        scale_color_manual(
          name = "Proximity\nIntensity",
          values = c(
            "Low" = "#fee08b",
            "Medium" = "#fdae61",
            "High" = "#d73027"
          )
        ) +
        coord_sf(
          crs = 3857,        # match maptiles tiles; cropped raster sets the frame
          expand = FALSE
        ) +
        theme_void() +
        theme(
          legend.position = "bottom",
          legend.title = element_text(size = 12, face = "bold"),
          legend.text = element_text(size = 10),
          plot.margin = margin(15, 15, 35, 15)
        )
      
      ggsave(
        file.path(dir_figures, "figure_1.png"),
        plot = tertile_map,
        width = 5,
        height = 6.5,
        dpi = 300,
        bg = "white"
      )
      cat("Map saved to figures directory\n")
    }
  }
}

# 4: Merge Classification to Price Dataset ----

{
  cat("\n=== PART 4: MERGING TERTILE CLASSIFICATION TO PRICE DATASET ===\n")
  
  if (exists("supermarket_data") && nrow(supermarket_data) > 0) {
    # Load the price dataset
    price_file <- file.path(dir_data_final_store, "POM_Prices_Long_Clean.csv")
    
    if (file.exists(price_file)) {
      cat("Loading price dataset...\n")
      price_data <- fread(price_file)
      
      # Create classification lookup
      classification <- supermarket_data %>%
        select(Name, proximity_tertile, proximity_binary) %>%
        rename(Supermarket = Name)
      
      # Merge classification into price data
      cat("Merging tertile classification...\n")
      price_data_updated <- price_data %>%
        select(
          -any_of(c(
            "proximity_binary",
            "proximity_tertile",
            "proximity_intensity",
            "class"
          ))
        ) %>%
        left_join(classification, by = "Supermarket")
      
      # Save updated CSV with character values
      fwrite(
        price_data_updated,
        file.path(dir_data_final_store, "POM_Prices_Long_Clean.csv")
      )
      cat("Updated .csv file saved\n")
      
      # Also save as .dta if haven package is available
      if (require("haven", quietly = TRUE)) {
        # Create numeric version for Stata
        price_data_dta <- price_data_updated %>%
          mutate(
            proximity_tertile_num = case_when(
              as.character(proximity_tertile) == "Low" ~ 1,
              as.character(proximity_tertile) == "Medium" ~ 2,
              as.character(proximity_tertile) == "High" ~ 3,
              TRUE ~ NA_real_
            )
          ) %>%
          mutate(proximity_binary = as.character(proximity_binary)) %>%
          select(-proximity_tertile) %>%
          rename(proximity_tertile = proximity_tertile_num)
        
        # Add value labels for Stata
        price_data_dta$proximity_tertile <- haven::labelled(
          price_data_dta$proximity_tertile,
          labels = c("Low" = 1, "Medium" = 2, "High" = 3)
        )
        
        write_dta(
          price_data_dta,
          file.path(dir_data_final_store, "POM_Prices_Long_Clean.dta")
        )
        cat("Updated .dta file saved\n")
      } else {
        cat("Warning: haven package not available - .dta file not created\n")
      }
      
      cat("\n=== Tertile Classification Summary ===\n")
      cat(
        "Total observations with classification:",
        sum(!is.na(price_data_updated$proximity_tertile)),
        "\n"
      )
      print(table(price_data_updated$proximity_tertile, useNA = "ifany"))
      
      cat("\nSupermarkets by tertile classification:\n")
      tertile_summary <- price_data_updated %>%
        distinct(Supermarket, proximity_tertile) %>%
        arrange(proximity_tertile, Supermarket) %>%
        as.data.frame()
      print(tertile_summary, row.names = FALSE)
    } else {
      cat("Warning: Price dataset not found at", price_file, "\n")
      cat("Classification not merged to price data\n")
    }
  }
}

cat("\n=== Port Moresby Analysis Complete ===\n\n")
