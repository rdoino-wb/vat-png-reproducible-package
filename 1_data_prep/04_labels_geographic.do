/*==============================================================================
 04_labels_geographic.do
 VAT exemption pass-through and incidence (Papua New Guinea) — data preparation

 PURPOSE : Define geographic value labels (provinces, districts, LLGs, wards,
           census units) from PNG census/survey codes for use across scripts.
 INPUTS  : none (label definitions only)
 OUTPUTS : none (in-memory value labels: s1q13, s1q14, s1q15, ...)
 DEPENDS : 01_globals.do
 CALLED BY: main.do
==============================================================================*/

********************************************************************************
* SECTION 6: GEOGRAPHIC LABELS (CENSUS/SURVEY CODES)
********************************************************************************

display as text "Loading geographic labels (provinces, districts, LLGs, wards, census units)..."
display as text "This may take a moment..."

label define s1q13 1 `"Western Province"', modify
label define s1q13 2 `"Gulf Province"', modify
label define s1q13 3 `"Central Province"', modify
label define s1q13 4 `"National Capital District"', modify
label define s1q13 5 `"Milne Bay Province"', modify
label define s1q13 6 `"Northern (Oro) Province"', modify
label define s1q13 7 `"Southern Highlands Province"', modify
label define s1q13 8 `"Enga Province"', modify
label define s1q13 9 `"Western Highlands Province"', modify
label define s1q13 10 `"Chimbu (Simbu) Province"', modify
label define s1q13 11 `"Eastern Highlands Province"', modify
label define s1q13 12 `"Morobe Province"', modify
label define s1q13 13 `"Madang Province"', modify
label define s1q13 14 `"East Sepik Province"', modify
label define s1q13 15 `"West Sepik (Sandaun) Province"', modify
label define s1q13 16 `"Manus Province"', modify
label define s1q13 17 `"New Ireland Province"', modify
label define s1q13 18 `"East New Britain Province"', modify
label define s1q13 19 `"West New Britain Province"', modify
label define s1q13 20 `"Autonomous Region of Bougainville"', modify
label define s1q13 21 `"Hela Province"', modify
label define s1q13 22 `"Jiwaka Province"', modify
label define s1q14 101 `"Middle Fly District"', modify
label define s1q14 102 `"North Fly District"', modify
label define s1q14 103 `"South Fly District"', modify
label define s1q14 104 `"Delta Fly District"', modify
label define s1q14 201 `"Kerema District"', modify
label define s1q14 202 `"Kikori District"', modify
label define s1q14 301 `"Abau District"', modify
label define s1q14 302 `"Goilala District"', modify
label define s1q14 303 `"Kairuku District"', modify
label define s1q14 304 `"Rigo District"', modify
label define s1q14 305 `"Hiri-Koiari District"', modify
label define s1q14 401 `"National Capital District"', modify
label define s1q14 501 `"Alotau District"', modify
label define s1q14 502 `"Samarai-Murua District"', modify
label define s1q14 503 `"Kiriwina-Goodenough District"', modify
label define s1q14 504 `"Esa'ala District"', modify
label define s1q14 601 `"Ijivitari District"', modify
label define s1q14 602 `"Sohe District"', modify
label define s1q14 603 `"Popondetta District"', modify
label define s1q14 701 `"Ialibu/Pangia District"', modify
label define s1q14 702 `"Imbonggu District"', modify
label define s1q14 703 `"Kagua/Erave District"', modify
label define s1q14 706 `"Mendi/Munihu District"', modify
label define s1q14 707 `"Nipa/Kutubu District"', modify
label define s1q14 708 `"Ialibu-Pangia District"', modify
label define s1q14 801 `"Kandep District"', modify
label define s1q14 802 `"Kompiam District"', modify
label define s1q14 803 `"Lagaip District"', modify
label define s1q14 804 `"Wabag District"', modify
label define s1q14 805 `"Wapenamanda District"', modify
label define s1q14 806 `"Porgera-Paiela District"', modify
label define s1q14 902 `"Dei District"', modify
label define s1q14 903 `"Mt Hagen District"', modify
label define s1q14 905 `"Mul/Baiyer District"', modify
label define s1q14 907 `"Tambul/Nebilyer District"', modify
label define s1q14 1001 `"Chuave District"', modify
label define s1q14 1002 `"Gumine District"', modify
label define s1q14 1003 `"Karimui/Nomane District"', modify
label define s1q14 1004 `"Kerowagi District"', modify
label define s1q14 1005 `"Kundiawa/Gembogl District"', modify
label define s1q14 1006 `"Sina Sina Yonggomugl District"', modify
label define s1q14 1101 `"Daulo District"', modify
label define s1q14 1102 `"Goroka District"', modify
label define s1q14 1103 `"Henganofi District"', modify
label define s1q14 1104 `"Kainanatu District"', modify
label define s1q14 1105 `"Lufa District"', modify
label define s1q14 1106 `"Obura/Wonenara District"', modify
label define s1q14 1107 `"Okapa District"', modify
label define s1q14 1108 `"Unggai/Benna District"', modify
label define s1q14 1201 `"Bulolo District"', modify
label define s1q14 1202 `"Finschafen District"', modify
label define s1q14 1203 `"Huon District"', modify
label define s1q14 1204 `"Kabwum District"', modify
label define s1q14 1205 `"Lae District"', modify
label define s1q14 1206 `"Markham District"', modify
label define s1q14 1207 `"Menyamya District"', modify
label define s1q14 1208 `"Nawae District"', modify
label define s1q14 1209 `"Tawae/Siassi District"', modify
label define s1q14 1210 `"Wau-Waria District"', modify
label define s1q14 1211 `"Usino Bundi District"', modify
label define s1q14 1301 `"Bogia District"', modify
label define s1q14 1302 `"Madang District"', modify
label define s1q14 1303 `"Middle Ramu District"', modify
label define s1q14 1304 `"Rai Coast District"', modify
label define s1q14 1305 `"Sumkar District"', modify
label define s1q14 1306 `"Usino Bundi District"', modify
label define s1q14 1401 `"Ambunti/Drekikier District"', modify
label define s1q14 1402 `"Angoram District"', modify
label define s1q14 1403 `"Maprik District"', modify
label define s1q14 1404 `"Wewak District"', modify
label define s1q14 1405 `"Wosera Gawi District"', modify
label define s1q14 1406 `"Yangoru Saussia District"', modify
label define s1q14 1501 `"Aitape/Lumi District"', modify
label define s1q14 1502 `"Nuku District"', modify
label define s1q14 1503 `"Telefomin District"', modify
label define s1q14 1504 `"Vanimo/Green River District"', modify
label define s1q14 1601 `"Manus District"', modify
label define s1q14 1701 `"Kavieng District"', modify
label define s1q14 1702 `"Namatanai District"', modify
label define s1q14 1801 `"Gazelle District"', modify
label define s1q14 1802 `"Kokopo District"', modify
label define s1q14 1803 `"Pomio District"', modify
label define s1q14 1804 `"Rabaul District"', modify
label define s1q14 1901 `"Kandrian/Gloucester District"', modify
label define s1q14 1902 `"Talasea District"', modify
label define s1q14 1903 `"Nakanai District"', modify
label define s1q14 2001 `"North Bougainville District"', modify
label define s1q14 2002 `"Central Bougainville District"', modify
label define s1q14 2003 `"South Bougainville District"', modify
label define s1q14 2104 `"Komo/Magarima District"', modify
label define s1q14 2105 `"Koroba/Kopiago District"', modify
label define s1q14 2108 `"Tari/Pori District"', modify
label define s1q14 2109 `"Magarima District"', modify
label define s1q14 2201 `"Anglimp/South Waghi District"', modify
label define s1q14 2204 `"Jimi District"', modify
label define s1q14 2206 `"North Waghi District"', modify
label define s1q15 1010180 `"Balimo Urban"', modify
label define s1q15 1010201 `"Samakopa"', modify
label define s1q15 1010202 `"Kawalasi"', modify
label define s1q15 1010203 `"Kamusi"', modify
label define s1q15 1010205 `"Bibisa"', modify
label define s1q15 1010206 `"Gagori"', modify
label define s1q15 1010207 `"Iowa"', modify
label define s1q15 1010208 `"Garu"', modify
label define s1q15 1010209 `"Miruwo"', modify
label define s1q15 1010210 `"Wakau/Sogere"', modify
label define s1q15 1010211 `"Asaramio"', modify
label define s1q15 1010212 `"Bina"', modify
label define s1q15 1010213 `"Sisiam"', modify
label define s1q15 1010214 `"Torobina"', modify
label define s1q15 1010215 `"Bamio"', modify
label define s1q15 1010216 `"Pirupiru"', modify
label define s1q15 1010217 `"Ukusi"', modify
label define s1q15 1010218 `"Nemeti"', modify
label define s1q15 1010219 `"Ibuo"', modify
label define s1q15 1010301 `"Ali"', modify
label define s1q15 1010302 `"Makapa"', modify
label define s1q15 1010303 `"Isago"', modify
label define s1q15 1010304 `"Pikiwa"', modify
label define s1q15 1010305 `"Wasapea"', modify
label define s1q15 1010306 `"Pisi"', modify
label define s1q15 1010307 `"Semabo"', modify
label define s1q15 1010308 `"Awaba"', modify
label define s1q15 1010309 `"Dadi"', modify
label define s1q15 1010310 `"Aketa"', modify
label define s1q15 1010311 `"Kawito Station"', modify
label define s1q15 1010312 `"Kotale"', modify
label define s1q15 1010313 `"Kewa"', modify
label define s1q15 1010314 `"Tai"', modify
label define s1q15 1010315 `"Dogona"', modify
label define s1q15 1010316 `"Adiba"', modify
label define s1q15 1010317 `"Yau"', modify
label define s1q15 1010318 `"Ike"', modify
label define s1q15 1010319 `"Kini"', modify
label define s1q15 1010320 `"Waligi"', modify
label define s1q15 1010321 `"Kimama"', modify
label define s1q15 1010322 `"Bamutsa"', modify
label define s1q15 1010323 `"Uladu"', modify
label define s1q15 1010324 `"Ugu"', modify
label define s1q15 1010325 `"Kenewa"', modify
label define s1q15 1010326 `"Waya"', modify
label define s1q15 1010327 `"Kubu"', modify
label define s1q15 1010328 `"Duaba"', modify
label define s1q15 1010329 `"Konedobu"', modify
label define s1q15 1010330 `"Pagona"', modify
label define s1q15 1010331 `"Dede"', modify
label define s1q15 1010332 `"Sialoa"', modify
label define s1q15 1010333 `"Kawiyapo"', modify
label define s1q15 1010334 `"Uric"', modify
label define s1q15 1010335 `"Aduru"', modify
label define s1q15 1010336 `"Baramula"', modify
label define s1q15 1010337 `"Tapila"', modify
label define s1q15 1010338 `"Lewada"', modify
label define s1q15 1010339 `"Dewara"', modify
label define s1q15 1010401 `"Upovia"', modify
label define s1q15 1010402 `"Buseki"', modify
label define s1q15 1010403 `"Boimbulavu"', modify
label define s1q15 1010404 `"Nago"', modify
label define s1q15 1010405 `"Maka"', modify
label define s1q15 1010406 `"Magipopo"', modify
label define s1q15 1010407 `"Usukof No 1"', modify
label define s1q15 1010408 `"Usokof No 2"', modify
label define s1q15 1010409 `"Kapikam"', modify
label define s1q15 1010410 `"Dimu"', modify
label define s1q15 1010411 `"Pangoa"', modify
label define s1q15 1010412 `"Tagum"', modify
label define s1q15 1010413 `"Miwa No 1."', modify
label define s1q15 1010414 `"Miwa No 2."', modify
label define s1q15 1010415 `"Kusikina"', modify
label define s1q15 1010416 `"Kuem"', modify
label define s1q15 1010417 `"Mipan"', modify
label define s1q15 1010418 `"Manda"', modify
label define s1q15 1010419 `"Bosset No 1"', modify
label define s1q15 1010420 `"Bosset No.2"', modify
label define s1q15 1010421 `"Wangawanga No 1"', modify
label define s1q15 1010422 `"Wangawanga No 2"', modify
label define s1q15 1010423 `"Komovai"', modify
label define s1q15 1010424 `"Kaviananga No.1"', modify
label define s1q15 1010425 `"Kaviananga No.2"', modify
label define s1q15 1010426 `"Boikmava"', modify
label define s1q15 1010427 `"Levame"', modify
label define s1q15 1010428 `"Lake Murray Station"', modify
label define s1q15 1010501 `"Igimi"', modify
label define s1q15 1010502 `"Mougulu"', modify
label define s1q15 1010503 `"Kofabi"', modify
label define s1q15 1010504 `"Adumari"', modify
label define s1q15 1010505 `"Ugubi"', modify
label define s1q15 1010506 `"Sefalobi"', modify
label define s1q15 1010507 `"Igibia"', modify
label define s1q15 1010508 `"Sedado"', modify
label define s1q15 1010509 `"Ugulubabi"', modify
label define s1q15 1010510 `"Sadubi"', modify
label define s1q15 1010511 `"Fuma"', modify
label define s1q15 1010512 `"Hafemi"', modify
label define s1q15 1010513 `"Yulabi"', modify
label define s1q15 1010514 `"Suabi"', modify
label define s1q15 1010516 `"Beredina"', modify
label define s1q15 1010517 `"Pipila"', modify
label define s1q15 1010518 `"Wakela"', modify
label define s1q15 1010519 `"Egebila"', modify
label define s1q15 1010520 `"Honabi"', modify
label define s1q15 1010521 `"Udugombi"', modify
label define s1q15 1010522 `"Kukudobi"', modify
label define s1q15 1010523 `"Sirigubi"', modify
label define s1q15 1010524 `"Mabomanibi"', modify
label define s1q15 1010525 `"Wasubi"', modify
label define s1q15 1010526 `"Bubusmabi"', modify
label define s1q15 1010527 `"Aeyedubi"', modify
label define s1q15 1010528 `"Tinahai"', modify
label define s1q15 1010529 `"Sinabi"', modify
label define s1q15 1010530 `"Wanbi"', modify
label define s1q15 1010531 `"Kwobi"', modify
label define s1q15 1010532 `"Testabi"', modify
label define s1q15 1010533 `"Kuda"', modify
label define s1q15 1010534 `"Debepari"', modify
label define s1q15 1010535 `"Sokabi"', modify
label define s1q15 1010536 `"Honinabi"', modify
label define s1q15 1010537 `"Nomad Station"', modify
label define s1q15 1010538 `"Dodomona"', modify
label define s1q15 1020601 `"Briompinai"', modify
label define s1q15 1020602 `"Timindemasok"', modify
label define s1q15 1020603 `"Atkamba"', modify
label define s1q15 1020604 `"Dome"', modify
label define s1q15 1020605 `"Gi"', modify
label define s1q15 1020606 `"Gre"', modify
label define s1q15 1020607 `"Griengas"', modify
label define s1q15 1020608 `"Drindamasuk"', modify
label define s1q15 1020609 `"Drimgas"', modify
label define s1q15 1020610 `"Gasuke"', modify
label define s1q15 1020611 `"Gusiore"', modify
label define s1q15 1020612 `"Timingondok"', modify
label define s1q15 1020613 `"Drimskai"', modify
label define s1q15 1020614 `"Timinsiriap"', modify
label define s1q15 1020615 `"Kukujaba"', modify
label define s1q15 1020616 `"Membok"', modify
label define s1q15 1020617 `"Erekta"', modify
label define s1q15 1020618 `"Moian"', modify
label define s1q15 1020619 `"Komokpin"', modify
label define s1q15 1020620 `"Menemsore"', modify
label define s1q15 1020621 `"Miasomnai"', modify
label define s1q15 1020622 `"Tiomnai"', modify
label define s1q15 1020623 `"Konkonda"', modify
label define s1q15 1020624 `"Yulawas"', modify
label define s1q15 1020625 `"Diabi"', modify
label define s1q15 1020626 `"Dabike"', modify
label define s1q15 1020627 `"Ieran"', modify
label define s1q15 1020628 `"Iogi"', modify
label define s1q15 1020629 `"Ralengre"', modify
label define s1q15 1020630 `"Tamifen"', modify
label define s1q15 1020631 `"Refugee Settlement"', modify
label define s1q15 1020781 `"Kiunga Urban"', modify
label define s1q15 1020801 `"Ambaga"', modify
label define s1q15 1020802 `"Kungim"', modify
label define s1q15 1020803 `"Tengkim"', modify
label define s1q15 1020804 `"Hukim"', modify
label define s1q15 1020805 `"Tarakbits"', modify
label define s1q15 1020806 `"Ogun/Ambaga"', modify
label define s1q15 1020807 `"Kwikim"', modify
label define s1q15 1020808 `"Bankim No.1"', modify
label define s1q15 1020809 `"Wulimkanatgo"', modify
label define s1q15 1020810 `"Kolebon"', modify
label define s1q15 1020811 `"Wogam"', modify
label define s1q15 1020812 `"Hoirenkia"', modify
label define s1q15 1020813 `"Sisimakam"', modify
label define s1q15 1020814 `"Mohomtienai"', modify
label define s1q15 1020815 `"Runai"', modify
label define s1q15 1020816 `"Hawenai"', modify
label define s1q15 1020817 `"Tmoknai"', modify
label define s1q15 1020818 `"Sonai"', modify
label define s1q15 1020819 `"Pampenai"', modify
label define s1q15 1020820 `"Yenkenai"', modify
label define s1q15 1020821 `"Matkomrae"', modify
label define s1q15 1020822 `"Dande"', modify
label define s1q15 1020823 `"Miamrae"', modify
label define s1q15 1020824 `"Ningerum Station"', modify
label define s1q15 1020901 `"Bolongong"', modify
label define s1q15 1020902 `"Kongabip"', modify
label define s1q15 1020903 `"Laubip"', modify
label define s1q15 1020904 `"Imigabip"', modify
label define s1q15 1020905 `"Duwinim/Tamtem"', modify
label define s1q15 1020906 `"Golgobip"', modify
label define s1q15 1020907 `"Bolibip"', modify
label define s1q15 1020908 `"Darabik"', modify
label define s1q15 1020909 `"Duminak"', modify
label define s1q15 1020910 `"Biangabip"', modify
label define s1q15 1020911 `"Selbang"', modify
label define s1q15 1020912 `"Seltamin"', modify
label define s1q15 1020913 `"Fagobip"', modify
label define s1q15 1020914 `"Saganabip"', modify
label define s1q15 1020915 `"Yasap"', modify
label define s1q15 1020916 `"Dahamo"', modify
label define s1q15 1021001 `"Atemkit"', modify
label define s1q15 1021002 `"Kavorabip"', modify
label define s1q15 1021003 `"Bultem"', modify
label define s1q15 1021004 `"Finalbin"', modify
label define s1q15 1021005 `"Wangbin"', modify
label define s1q15 1021006 `"Migalsimbip"', modify
label define s1q15 1021007 `"Niosikwi"', modify
label define s1q15 1021008 `"Ok Tedi Tau"', modify
label define s1q15 1021009 `"Kumkit"', modify
label define s1q15 1021010 `"Ankits"', modify
label define s1q15 1021011 `"Kawemtigin"', modify
label define s1q15 1021012 `"Korokit"', modify
label define s1q15 1021082 `"Tabubil Town"', modify
label define s1q15 1031183 `"Daru Town"', modify
label define s1q15 1031201 `"Sigabaduru"', modify
label define s1q15 1031202 `"Mabudawan"', modify
label define s1q15 1031203 `"Tureture"', modify
label define s1q15 1031204 `"Sui"', modify
label define s1q15 1031205 `"Severimabu"', modify
label define s1q15 1031206 `"Doumori"', modify
label define s1q15 1031207 `"Variobadoro"', modify
label define s1q15 1031208 `"Maduduo"', modify
label define s1q15 1031209 `"Tire'ere"', modify
label define s1q15 1031210 `"Wapi"', modify
label define s1q15 1031211 `"Sagasia"', modify
label define s1q15 1031212 `"Buzi"', modify
label define s1q15 1031213 `"Mawatta"', modify
label define s1q15 1031214 `"Parama"', modify
label define s1q15 1031215 `"Aberagerema"', modify
label define s1q15 1031216 `"Wabada"', modify
label define s1q15 1031217 `"Sepe"', modify
label define s1q15 1031218 `"Samari"', modify
label define s1q15 1031219 `"Kadawa"', modify
label define s1q15 1031220 `"Madame"', modify
label define s1q15 1031221 `"Maipani"', modify
label define s1q15 1031222 `"Kename"', modify
label define s1q15 1031223 `"U'uwo"', modify
label define s1q15 1031224 `"Katatai"', modify
label define s1q15 1031301 `"Bula"', modify
label define s1q15 1031302 `"Wereavere"', modify
label define s1q15 1031303 `"Wemnevere"', modify
label define s1q15 1031304 `"Mibini"', modify
label define s1q15 1031305 `"Garaita"', modify
label define s1q15 1031306 `"Pongariki"', modify
label define s1q15 1031307 `"Dimisisi"', modify
label define s1q15 1031308 `"Sibidiri"', modify
label define s1q15 1031309 `"Limol"', modify
label define s1q15 1031310 `"Keru"', modify
label define s1q15 1031311 `"Pukaduka"', modify
label define s1q15 1031312 `"Kiriwo"', modify
label define s1q15 1031313 `"Aewe"', modify
label define s1q15 1031314 `"Wando"', modify
label define s1q15 1031315 `"Kandarisa"', modify
label define s1q15 1031316 `"Rouku"', modify
label define s1q15 1031317 `"Morehead Station"', modify
label define s1q15 1031318 `"Bimadeben"', modify
label define s1q15 1031319 `"Eniyawa"', modify
label define s1q15 1031320 `"Kautru"', modify
label define s1q15 1031321 `"Kondobol"', modify
label define s1q15 1031322 `"Malam"', modify
label define s1q15 1031401 `"Dorogori"', modify
label define s1q15 1031402 `"Wuroi"', modify
label define s1q15 1031403 `"Wonie"', modify
label define s1q15 1031404 `"Iamega"', modify
label define s1q15 1031405 `"Wipim"', modify
label define s1q15 1031406 `"Gamaeve"', modify
label define s1q15 1031407 `"Tewara"', modify
label define s1q15 1031408 `"Kapal"', modify
label define s1q15 1031409 `"Upiara"', modify
label define s1q15 1031410 `"Giringarede"', modify
label define s1q15 1031411 `"U'ume"', modify
label define s1q15 1031412 `"Masingara"', modify
label define s1q15 1031413 `"Kunini"', modify
label define s1q15 1031414 `"Iru'upi"', modify
label define s1q15 1031415 `"Waidoro"', modify
label define s1q15 1031416 `"Kulalai"', modify
label define s1q15 1031417 `"Wamarong"', modify
label define s1q15 1031418 `"Sebe"', modify
label define s1q15 1031419 `"Wim"', modify
label define s1q15 1031420 `"Sogale"', modify
label define s1q15 1031421 `"Kurunti"', modify
label define s1q15 1031422 `"Abam"', modify
label define s1q15 1031423 `"Boze"', modify
label define s1q15 1031424 `"Bisuaka"', modify
label define s1q15 1031425 `"Podare"', modify
label define s1q15 2010101 `"Uaripi"', modify
label define s1q15 2010102 `"Mei'i"', modify
label define s1q15 2010103 `"Lapari"', modify
label define s1q15 2010104 `"Mirakere"', modify
label define s1q15 2010105 `"Didimaua"', modify
label define s1q15 2010106 `"Uriri"', modify
label define s1q15 2010107 `"Silo"', modify
label define s1q15 2010108 `"Uamai No. 1"', modify
label define s1q15 2010109 `"Uamai No. 2"', modify
label define s1q15 2010110 `"Karama"', modify
label define s1q15 2010111 `"Pukari"', modify
label define s1q15 2010112 `"Koaru"', modify
label define s1q15 2010113 `"Meporo"', modify
label define s1q15 2010201 `"Lelefiru"', modify
label define s1q15 2010202 `"Kukipi"', modify
label define s1q15 2010203 `"Uritai"', modify
label define s1q15 2010204 `"Popo"', modify
label define s1q15 2010205 `"Lese"', modify
label define s1q15 2010206 `"Miaru"', modify
label define s1q15 2010207 `"Iokea"', modify
label define s1q15 2010208 `"Sarota"', modify
label define s1q15 2010301 `"Bema"', modify
label define s1q15 2010302 `"Mine"', modify
label define s1q15 2010303 `"Wimka"', modify
label define s1q15 2010304 `"Wempango"', modify
label define s1q15 2010305 `"Kaingo"', modify
label define s1q15 2010306 `"Hambia"', modify
label define s1q15 2010307 `"Yemepango"', modify
label define s1q15 2010308 `"Hawabango"', modify
label define s1q15 2010309 `"Karangea"', modify
label define s1q15 2010310 `"Kwoi'amunga"', modify
label define s1q15 2010311 `"Kengo"', modify
label define s1q15 2010312 `"Hapataewa"', modify
label define s1q15 2010313 `"Kaintiba Station"', modify
label define s1q15 2010314 `"Ikose"', modify
label define s1q15 2010315 `"Yakitangwa"', modify
label define s1q15 2010481 `"Kerema Town"', modify
label define s1q15 2010501 `"Kanabea"', modify
label define s1q15 2010502 `"Ipaiyu"', modify
label define s1q15 2010503 `"Manimango"', modify
label define s1q15 2010504 `"Wemawa"', modify
label define s1q15 2010505 `"Komako"', modify
label define s1q15 2010506 `"Kwaiyu"', modify
label define s1q15 2010507 `"Bu'u"', modify
label define s1q15 2010508 `"Pio"', modify
label define s1q15 2010509 `"Anea"', modify
label define s1q15 2010510 `"Aminauwa"', modify
label define s1q15 2010511 `"M'bauya"', modify
label define s1q15 2010512 `"Ivandu"', modify
label define s1q15 2010513 `"Hawakabia"', modify
label define s1q15 2010514 `"Kamina"', modify
label define s1q15 2010515 `"Tiawa"', modify
label define s1q15 2010516 `"Paina"', modify
label define s1q15 2010517 `"Meiwari"', modify
label define s1q15 2010518 `"Kutumbaiwa"', modify
label define s1q15 2010519 `"Kotidanga"', modify
label define s1q15 2010520 `"Ipaea"', modify
label define s1q15 2010601 `"Ipihia/Titikaini"', modify
label define s1q15 2010602 `"Wanto"', modify
label define s1q15 2010603 `"Kakiva"', modify
label define s1q15 2010604 `"Putei"', modify
label define s1q15 2010605 `"Kakoro"', modify
label define s1q15 2010606 `"Okaivai"', modify
label define s1q15 2010607 `"Heavala"', modify
label define s1q15 2010608 `"Heatoare"', modify
label define s1q15 2010683 `"Malalaua Urban"', modify
label define s1q15 2020701 `"Amipoke"', modify
label define s1q15 2020703 `"Karurua  Station"', modify
label define s1q15 2020704 `"Bekoro"', modify
label define s1q15 2020705 `"Mariki"', modify
label define s1q15 2020706 `"Varia"', modify
label define s1q15 2020707 `"Korovake"', modify
label define s1q15 2020708 `"Ara'ava"', modify
label define s1q15 2020709 `"Kaiarimai"', modify
label define s1q15 2020710 `"Kapuna"', modify
label define s1q15 2020711 `"Kinibo"', modify
label define s1q15 2020712 `"Ikinu"', modify
label define s1q15 2020713 `"Akoma"', modify
label define s1q15 2020714 `"Mapaio"', modify
label define s1q15 2020715 `"Aikavaravi"', modify
label define s1q15 2020716 `"Maipenairu"', modify
label define s1q15 2020717 `"Kapai"', modify
label define s1q15 2020718 `"Apiope"', modify
label define s1q15 2020719 `"Aumu"', modify
label define s1q15 2020720 `"Poroi"', modify
label define s1q15 2020721 `"Wabo"', modify
label define s1q15 2020722 `"Uraru"', modify
label define s1q15 2020723 `"Haia"', modify
label define s1q15 2020780 `"Baimuru Station"', modify
label define s1q15 2020801 `"Negebare"', modify
label define s1q15 2020802 `"Tobare"', modify
label define s1q15 2020803 `"Sera"', modify
label define s1q15 2020804 `"Omo"', modify
label define s1q15 2020805 `"Kabarau"', modify
label define s1q15 2020806 `"Irimuku"', modify
label define s1q15 2020807 `"Morere"', modify
label define s1q15 2020808 `"Ero"', modify
label define s1q15 2020809 `"Veraibari"', modify
label define s1q15 2020810 `"Kivaumai"', modify
label define s1q15 2020811 `"Morovamu"', modify
label define s1q15 2020812 `"Wowoubo"', modify
label define s1q15 2020813 `"Waitari"', modify
label define s1q15 2020814 `"Nahoromere"', modify
label define s1q15 2020815 `"Era Maipua"', modify
label define s1q15 2020901 `"Avavu"', modify
label define s1q15 2020902 `"Harevavo"', modify
label define s1q15 2020903 `"Kaivukavu"', modify
label define s1q15 2020904 `"Arehava"', modify
label define s1q15 2020905 `"Kavava"', modify
label define s1q15 2020906 `"Harilarewa"', modify
label define s1q15 2020907 `"Lariau"', modify
label define s1q15 2020908 `"Pakovavu"', modify
label define s1q15 2020909 `"Haruape"', modify
label define s1q15 2020911 `"Lovehoho"', modify
label define s1q15 2020912 `"Ovahuhu"', modify
label define s1q15 2020913 `"Vailala"', modify
label define s1q15 2020914 `"Karokaro"', modify
label define s1q15 2020915 `"Herehere"', modify
label define s1q15 2020916 `"Koialahu"', modify
label define s1q15 2020917 `"Lepokela"', modify
label define s1q15 2020918 `"Akapiru"', modify
label define s1q15 2020919 `"Hepa"', modify
label define s1q15 2020920 `"Heawa"', modify
label define s1q15 2020921 `"Mailava"', modify
label define s1q15 2020922 `"Belepa"', modify
label define s1q15 2020984 `"Ihu Station"', modify
label define s1q15 2021001 `"Haivaro"', modify
label define s1q15 2021002 `"Moka"', modify
label define s1q15 2021003 `"Komaio"', modify
label define s1q15 2021004 `"Masusu"', modify
label define s1q15 2021005 `"Gibu"', modify
label define s1q15 2021006 `"Ekeirau"', modify
label define s1q15 2021007 `"Kibeni"', modify
label define s1q15 2021008 `"Omati-Gihiteri"', modify
label define s1q15 2021009 `"Kaiam"', modify
label define s1q15 2021010 `"Baina"', modify
label define s1q15 2021011 `"Kemei"', modify
label define s1q15 2021012 `"Dopima"', modify
label define s1q15 2021013 `"Babaguina"', modify
label define s1q15 2021014 `"Apeawa"', modify
label define s1q15 2021015 `"Doibo"', modify
label define s1q15 2021017 `"Kopi"', modify
label define s1q15 2021082 `"Kikori Urban"', modify
label define s1q15 3010101 `"Aloke/Nonou"', modify
label define s1q15 3010102 `"Daena / Warumana"', modify
label define s1q15 3010103 `"Maraoro/Kenene"', modify
label define s1q15 3010104 `"Dorio/Bua"', modify
label define s1q15 3010105 `"Dagaea Oro/Abati"', modify
label define s1q15 3010106 `"Danava/Goiseoro"', modify
label define s1q15 3010107 `"Barauoro"', modify
label define s1q15 3010108 `"Ade/Ebu"', modify
label define s1q15 3010109 `"Launoga"', modify
label define s1q15 3010110 `"Banaoro"', modify
label define s1q15 3010111 `"Losoa/Bogia"', modify
label define s1q15 3010201 `"Paramana"', modify
label define s1q15 3010202 `"Pelagai"', modify
label define s1q15 3010203 `"Maopa"', modify
label define s1q15 3010204 `"Gaivakalana"', modify
label define s1q15 3010205 `"Waro/Iruone"', modify
label define s1q15 3010206 `"Kelekapana"', modify
label define s1q15 3010207 `"Wairavanua"', modify
label define s1q15 3010208 `"Kelerakwa"', modify
label define s1q15 3010209 `"Bukuku"', modify
label define s1q15 3010210 `"Upulima"', modify
label define s1q15 3010211 `"Waiori"', modify
label define s1q15 3010212 `"Wanigela"', modify
label define s1q15 3010214 `"Gavuone"', modify
label define s1q15 3010215 `"Kapari"', modify
label define s1q15 3010216 `"Lalaura"', modify
label define s1q15 3010284 `"Kupiano Urban"', modify
label define s1q15 3010301 `"Boru"', modify
label define s1q15 3010302 `"Doma"', modify
label define s1q15 3010303 `"Robinson River"', modify
label define s1q15 3010304 `"Si'ini"', modify
label define s1q15 3010305 `"Duramu"', modify
label define s1q15 3010306 `"Ganai"', modify
label define s1q15 3010307 `"Amau"', modify
label define s1q15 3010308 `"Ianu"', modify
label define s1q15 3010309 `"Domara"', modify
label define s1q15 3010310 `"Baramata"', modify
label define s1q15 3010311 `"Tutubu"', modify
label define s1q15 3010312 `"Merani"', modify
label define s1q15 3010313 `"Manabo"', modify
label define s1q15 3010314 `"Dom"', modify
label define s1q15 3010385 `"Moreguina Urban"', modify
label define s1q15 3020401 `"Zarima"', modify
label define s1q15 3020402 `"Kamulai"', modify
label define s1q15 3020403 `"Rupila"', modify
label define s1q15 3020404 `"Zhake"', modify
label define s1q15 3020501 `"Ivani"', modify
label define s1q15 3020502 `"Central Ivane"', modify
label define s1q15 3020503 `"Sopu"', modify
label define s1q15 3020504 `"Kerau"', modify
label define s1q15 3020505 `"Kataipa"', modify
label define s1q15 3020506 `"Jova"', modify
label define s1q15 3020507 `"Loloipa"', modify
label define s1q15 3020508 `"Pilitu 1"', modify
label define s1q15 3020509 `"Pilitu 2"', modify
label define s1q15 3020580 `"Tapini Urban"', modify
label define s1q15 3020601 `"Chirima"', modify
label define s1q15 3020602 `"Chirima Valley"', modify
label define s1q15 3020603 `"Dilava"', modify
label define s1q15 3020604 `"Fane"', modify
label define s1q15 3020605 `"Auga"', modify
label define s1q15 3020606 `"Woitape"', modify
label define s1q15 3020607 `"Ononge"', modify
label define s1q15 3020608 `"Aduai"', modify
label define s1q15 3020609 `"Woitape Station"', modify
label define s1q15 3030701 `"Porebada"', modify
label define s1q15 3030702 `"Boera"', modify
label define s1q15 3030703 `"Papa"', modify
label define s1q15 3030704 `"Roku"', modify
label define s1q15 3030705 `"Lealea"', modify
label define s1q15 3030706 `"Kido"', modify
label define s1q15 3030707 `"Manumanu"', modify
label define s1q15 3030708 `"Barakau"', modify
label define s1q15 3030709 `"Tubusereia"', modify
label define s1q15 3030710 `"Mt. Diamond"', modify
label define s1q15 3030711 `"Gaire"', modify
label define s1q15 3030712 `"Dagoda"', modify
label define s1q15 3030713 `"Akuku"', modify
label define s1q15 3030714 `"Laloki"', modify
label define s1q15 3030715 `"Vanapa"', modify
label define s1q15 3030716 `"Kerea"', modify
label define s1q15 3030717 `"Brown River"', modify
label define s1q15 3030718 `"Boteka"', modify
label define s1q15 3030801 `"Kivori"', modify
label define s1q15 3030802 `"Waima Abiara"', modify
label define s1q15 3030803 `"Waima/Kore"', modify
label define s1q15 3030804 `"Delena"', modify
label define s1q15 3030805 `"Nabuapaka"', modify
label define s1q15 3030806 `"Chiria"', modify
label define s1q15 3030807 `"Abiara"', modify
label define s1q15 3030808 `"Biotou"', modify
label define s1q15 3030809 `"Rapa"', modify
label define s1q15 3030810 `"Mou"', modify
label define s1q15 3030811 `"Babiko"', modify
label define s1q15 3030813 `"Nara"', modify
label define s1q15 3030814 `"Hisiu"', modify
label define s1q15 3030815 `"Gabadi/Pinu"', modify
label define s1q15 3030816 `"Malati"', modify
label define s1q15 3030817 `"Veimauri"', modify
label define s1q15 3030882 `"Bereina Urban"', modify
label define s1q15 3030901 `"Osabewai"', modify
label define s1q15 3030902 `"Mesime"', modify
label define s1q15 3030903 `"Vaiagai"', modify
label define s1q15 3030904 `"Furimuti"', modify
label define s1q15 3030905 `"Depo (Mageri)"', modify
label define s1q15 3030906 `"Vesilogo"', modify
label define s1q15 3030907 `"Bereadabu"', modify
label define s1q15 3030908 `"Kailaki"', modify
label define s1q15 3030909 `"Doe"', modify
label define s1q15 3030910 `"Ogotana"', modify
label define s1q15 3030911 `"Kahitana"', modify
label define s1q15 3030912 `"Berebei"', modify
label define s1q15 3030913 `"Varutanumu"', modify
label define s1q15 3030914 `"Suria/Kotoi"', modify
label define s1q15 3030915 `"Boridi"', modify
label define s1q15 3030916 `"Kagi"', modify
label define s1q15 3030917 `"Efogi"', modify
label define s1q15 3030918 `"Manari"', modify
label define s1q15 3030919 `"Edevu"', modify
label define s1q15 3030920 `"Sogeri Urban"', modify
label define s1q15 3030986 `"Goldie Urban 01"', modify
label define s1q15 3031001 `"Aipeana"', modify
label define s1q15 3031002 `"Veifa'a"', modify
label define s1q15 3031003 `"Rarai"', modify
label define s1q15 3031004 `"Ianwaui"', modify
label define s1q15 3031005 `"Eboa"', modify
label define s1q15 3031006 `"Inawabui"', modify
label define s1q15 3031007 `"Inawaia"', modify
label define s1q15 3031008 `"Inaoae"', modify
label define s1q15 3031009 `"Bebeo"', modify
label define s1q15 3031010 `"Jeku"', modify
label define s1q15 3031011 `"Inaui"', modify
label define s1q15 3031012 `"Ameiaka"', modify
label define s1q15 3031013 `"Babanongo"', modify
label define s1q15 3031014 `"Maipa"', modify
label define s1q15 3031015 `"Apanaipi"', modify
label define s1q15 3031016 `"Upper Kuni"', modify
label define s1q15 3031017 `"Lower Kuni"', modify
label define s1q15 3031018 `"Kubuina"', modify
label define s1q15 3031019 `"Bakoiudu"', modify
label define s1q15 3041101 `"Manugoro"', modify
label define s1q15 3041102 `"Girabu"', modify
label define s1q15 3041103 `"Gobuia"', modify
label define s1q15 3041104 `"Gomore"', modify
label define s1q15 3041105 `"Babaga (Saroa)"', modify
label define s1q15 3041106 `"Kemaea"', modify
label define s1q15 3041107 `"Kwalimurubu"', modify
label define s1q15 3041108 `"Gidobada"', modify
label define s1q15 3041109 `"Saroa"', modify
label define s1q15 3041110 `"Kodogere"', modify
label define s1q15 3041111 `"Geresi"', modify
label define s1q15 3041112 `"Wasira"', modify
label define s1q15 3041113 `"Kwikila Town"', modify
label define s1q15 3041114 `"Imuagoro"', modify
label define s1q15 3041115 `"Saroakeina"', modify
label define s1q15 3041116 `"Sivitatana"', modify
label define s1q15 3041117 `"Boregaina"', modify
label define s1q15 3041118 `"Daroakomana"', modify
label define s1q15 3041119 `"Bigairuka"', modify
label define s1q15 3041120 `"Bore"', modify
label define s1q15 3041121 `"Goulupu"', modify
label define s1q15 3041122 `"Niuiruka"', modify
label define s1q15 3041123 `"Rigo Koiari Iove"', modify
label define s1q15 3041124 `"Karekodobu"', modify
label define s1q15 3041125 `"Kware"', modify
label define s1q15 3041126 `"Gaunomu"', modify
label define s1q15 3041127 `"Nafenanomu"', modify
label define s1q15 3041128 `"Dirinimu"', modify
label define s1q15 3041181 `"Kwikila Urban"', modify
label define s1q15 3041201 `"Gabagaba"', modify
label define s1q15 3041202 `"Ginigolo"', modify
label define s1q15 3041203 `"Gunugau"', modify
label define s1q15 3041204 `"Tagana"', modify
label define s1q15 3041205 `"Gabone"', modify
label define s1q15 3041206 `"Tauruba"', modify
label define s1q15 3041207 `"Bonanamo"', modify
label define s1q15 3041208 `"Kemabolo"', modify
label define s1q15 3041209 `"Galomarupu"', modify
label define s1q15 3041210 `"Walai"', modify
label define s1q15 3041211 `"Babagarupu"', modify
label define s1q15 3041212 `"Riwalirupu"', modify
label define s1q15 3041213 `"Gemo"', modify
label define s1q15 3041214 `"Kaparoko"', modify
label define s1q15 3041215 `"Irupara"', modify
label define s1q15 3041216 `"Hula"', modify
label define s1q15 3041217 `"Babaka"', modify
label define s1q15 3041218 `"Kamali"', modify
label define s1q15 3041219 `"Kalo"', modify
label define s1q15 3041220 `"Makerupu"', modify
label define s1q15 3041221 `"Alukuni"', modify
label define s1q15 3041222 `"Karawa"', modify
label define s1q15 3041223 `"Keapara"', modify
label define s1q15 3041301 `"Upper Maria"', modify
label define s1q15 3041302 `"Central Maria"', modify
label define s1q15 3041303 `"East Maria"', modify
label define s1q15 3041304 `"West Maria"', modify
label define s1q15 3041305 `"Ormand East"', modify
label define s1q15 3041306 `"Ormand Central"', modify
label define s1q15 3041307 `"Ormand West"', modify
label define s1q15 3041308 `"Upper Mt Brown"', modify
label define s1q15 3041309 `"Central Mt Brown"', modify
label define s1q15 3041310 `"Lower Mt Brown"', modify
label define s1q15 3041311 `"Upper Boku/Doromu"', modify
label define s1q15 3041312 `"Central Boku/Doromu"', modify
label define s1q15 3041313 `"Lower Boku/Doromu"', modify
label define s1q15 3041314 `"Upper Mt. Obree"', modify
label define s1q15 3041315 `"Central Mt. Obree"', modify
label define s1q15 3041316 `"Lower Mt. Obree"', modify
label define s1q15 4010180 `"Gerehu Urban"', modify
label define s1q15 4010181 `"Waigani/University"', modify
label define s1q15 4010182 `"Tokarara/Hohola Urban"', modify
label define s1q15 4010183 `"Gordons/Saraga Urban"', modify
label define s1q15 4010184 `"Boroko / Korobosea Urban"', modify
label define s1q15 4010185 `"Kilakila / Kaugere Urban"', modify
label define s1q15 4010186 `"Town / Hanuabada Urban"', modify
label define s1q15 4010187 `"Laloki / Napanapa Urban"', modify
label define s1q15 4010188 `"Bomana Urban"', modify
label define s1q15 5010101 `"Bai'awa"', modify
label define s1q15 5010102 `"Midino"', modify
label define s1q15 5010103 `"Iarame"', modify
label define s1q15 5010104 `"Pem"', modify
label define s1q15 5010105 `"Magabara"', modify
label define s1q15 5010106 `"Tapio"', modify
label define s1q15 5010107 `"Mukawa"', modify
label define s1q15 5010108 `"Bogaboga"', modify
label define s1q15 5010109 `"Ginada"', modify
label define s1q15 5010110 `"Irikaba"', modify
label define s1q15 5010111 `"Wabubu"', modify
label define s1q15 5010112 `"Dabora"', modify
label define s1q15 5010113 `"Banapa"', modify
label define s1q15 5010114 `"Menapi"', modify
label define s1q15 5010115 `"Pora"', modify
label define s1q15 5010116 `"Abuaro"', modify
label define s1q15 5010117 `"Giwa"', modify
label define s1q15 5010118 `"Koiyabagira"', modify
label define s1q15 5010119 `"Kwagila"', modify
label define s1q15 5010120 `"Biniguni"', modify
label define s1q15 5010121 `"Wapon"', modify
label define s1q15 5010122 `"Borovia"', modify
label define s1q15 5010123 `"Pumani"', modify
label define s1q15 5010124 `"Bemberi"', modify
label define s1q15 5010125 `"Gurukwaia"', modify
label define s1q15 5010126 `"Mapouna"', modify
label define s1q15 5010201 `"Gaunani"', modify
label define s1q15 5010202 `"Birat"', modify
label define s1q15 5010203 `"Bonenau"', modify
label define s1q15 5010204 `"Param"', modify
label define s1q15 5010205 `"Kakaia"', modify
label define s1q15 5010206 `"Payawa"', modify
label define s1q15 5010207 `"Ilakae - Modeni"', modify
label define s1q15 5010208 `"Uni"', modify
label define s1q15 5010209 `"Bibitan"', modify
label define s1q15 5010210 `"Danawan"', modify
label define s1q15 5010211 `"Biman"', modify
label define s1q15 5010212 `"Gwagut"', modify
label define s1q15 5010213 `"Gwadede"', modify
label define s1q15 5010214 `"Eviaua"', modify
label define s1q15 5010215 `"Gwaira"', modify
label define s1q15 5010216 `"Kanaturu"', modify
label define s1q15 5010217 `"Gauwa"', modify
label define s1q15 5010218 `"Gwiroro"', modify
label define s1q15 5010301 `"Divari"', modify
label define s1q15 5010302 `"Kwabunaki"', modify
label define s1q15 5010303 `"Rumaruma"', modify
label define s1q15 5010304 `"Damayadona"', modify
label define s1q15 5010305 `"Wedau"', modify
label define s1q15 5010306 `"Manubada"', modify
label define s1q15 5010307 `"Vidia"', modify
label define s1q15 5010308 `"Radava"', modify
label define s1q15 5010309 `"Gadoa"', modify
label define s1q15 5010310 `"Wadobuna"', modify
label define s1q15 5010311 `"Nakara"', modify
label define s1q15 5010312 `"Uga"', modify
label define s1q15 5010313 `"Augwana"', modify
label define s1q15 5010314 `"Sirisiri"', modify
label define s1q15 5010315 `"Taramugu"', modify
label define s1q15 5010316 `"Ikara"', modify
label define s1q15 5010317 `"Taubadi"', modify
label define s1q15 5010318 `"Bidiesi"', modify
label define s1q15 5010319 `"Awawa"', modify
label define s1q15 5010320 `"Dombosaina"', modify
label define s1q15 5010321 `"Warawadidi"', modify
label define s1q15 5010322 `"Bowadi"', modify
label define s1q15 5010323 `"Danobu"', modify
label define s1q15 5010324 `"Karagautu"', modify
label define s1q15 5010325 `"Wanama"', modify
label define s1q15 5010326 `"Boiaboia"', modify
label define s1q15 5010327 `"Gadovisu"', modify
label define s1q15 5010328 `"Didia"', modify
label define s1q15 5010329 `"Mainawa"', modify
label define s1q15 5010330 `"Pova"', modify
label define s1q15 5010401 `"Lavora"', modify
label define s1q15 5010402 `"Topura"', modify
label define s1q15 5010403 `"Iapoa No. 1"', modify
label define s1q15 5010404 `"Wamawamana"', modify
label define s1q15 5010405 `"Taupota"', modify
label define s1q15 5010406 `"Garuahi"', modify
label define s1q15 5010407 `"Awaiama"', modify
label define s1q15 5010408 `"Keia"', modify
label define s1q15 5010409 `"Iapoa No. 2"', modify
label define s1q15 5010410 `"Porotana"', modify
label define s1q15 5010411 `"Huhuna"', modify
label define s1q15 5010412 `"Guga"', modify
label define s1q15 5010413 `"Wagohuhu"', modify
label define s1q15 5010414 `"Biwa"', modify
label define s1q15 5010415 `"Ibulai"', modify
label define s1q15 5010416 `"Ronana"', modify
label define s1q15 5010417 `"East Cape"', modify
label define s1q15 5010418 `"Iabam/Pahilele"', modify
label define s1q15 5010419 `"Nuakata"', modify
label define s1q15 5010501 `"Mutu'uwa"', modify
label define s1q15 5010502 `"Divinai"', modify
label define s1q15 5010503 `"Daio"', modify
label define s1q15 5010504 `"Rabe"', modify
label define s1q15 5010505 `"Ianeianene"', modify
label define s1q15 5010506 `"Siasiada"', modify
label define s1q15 5010507 `"Gibara"', modify
label define s1q15 5010508 `"Lamhaga"', modify
label define s1q15 5010509 `"Lelehudi"', modify
label define s1q15 5010510 `"Watunou"', modify
label define s1q15 5010511 `"Nigila"', modify
label define s1q15 5010512 `"Ahioma"', modify
label define s1q15 5010513 `"Waema"', modify
label define s1q15 5010514 `"Gabugabuna"', modify
label define s1q15 5010515 `"Maiwara"', modify
label define s1q15 5010516 `"Naura"', modify
label define s1q15 5010517 `"Gelamalaia"', modify
label define s1q15 5010518 `"Gamadoudou"', modify
label define s1q15 5010519 `"Wagawaga"', modify
label define s1q15 5010520 `"Gwavili"', modify
label define s1q15 5010521 `"Upper Dawadawa"', modify
label define s1q15 5010522 `"Bubuleta"', modify
label define s1q15 5010523 `"Walalaia"', modify
label define s1q15 5010524 `"Bou"', modify
label define s1q15 5010525 `"Ipouli"', modify
label define s1q15 5010526 `"Kilakilana"', modify
label define s1q15 5010527 `"Borowai"', modify
label define s1q15 5010528 `"Laviam"', modify
label define s1q15 5010529 `"Lower Dawadawa"', modify
label define s1q15 5010585 `"Hagita Estate"', modify
label define s1q15 5010601 `"Koukou"', modify
label define s1q15 5010602 `"Iloilo"', modify
label define s1q15 5010603 `"Bonarua"', modify
label define s1q15 5010604 `"Modewa"', modify
label define s1q15 5010605 `"Baibaisiga"', modify
label define s1q15 5010606 `"Suau Island"', modify
label define s1q15 5010607 `"Sibalai"', modify
label define s1q15 5010608 `"Ipulai"', modify
label define s1q15 5010609 `"Savalala"', modify
label define s1q15 5010610 `"Navabu"', modify
label define s1q15 5010611 `"Isuae"', modify
label define s1q15 5010612 `"Savaia"', modify
label define s1q15 5010613 `"Oyamamania"', modify
label define s1q15 5010614 `"Isudiudiu"', modify
label define s1q15 5010615 `"Saga'aho"', modify
label define s1q15 5010616 `"Isuisu"', modify
label define s1q15 5010617 `"Isudau"', modify
label define s1q15 5010618 `"Sea'sea Island"', modify
label define s1q15 5010619 `"Sea'sea North"', modify
label define s1q15 5010620 `"Silosilo"', modify
label define s1q15 5010621 `"Kaukau"', modify
label define s1q15 5010622 `"Bonabona Island"', modify
label define s1q15 5010623 `"Dahuni"', modify
label define s1q15 5010624 `"Leileiafa"', modify
label define s1q15 5010625 `"Suieabina"', modify
label define s1q15 5010626 `"Gadaisu"', modify
label define s1q15 5010627 `"Wadauda"', modify
label define s1q15 5010628 `"Boilave"', modify
label define s1q15 5010629 `"Takwatakwae"', modify
label define s1q15 5010780 `"Alotau Town"', modify
label define s1q15 5020801 `"Hamama"', modify
label define s1q15 5020802 `"Loani"', modify
label define s1q15 5020803 `"Logea"', modify
label define s1q15 5020804 `"Kwato"', modify
label define s1q15 5020805 `"Tegorauan"', modify
label define s1q15 5020806 `"Gotai"', modify
label define s1q15 5020807 `"Dawson"', modify
label define s1q15 5020808 `"Samarai East"', modify
label define s1q15 5020809 `"Kwaraiwa"', modify
label define s1q15 5020810 `"Sawasawaga"', modify
label define s1q15 5020811 `"Anagusa"', modify
label define s1q15 5020812 `"Samarai North"', modify
label define s1q15 5020813 `"Tubetube"', modify
label define s1q15 5020814 `"Yokowa"', modify
label define s1q15 5020815 `"Gigia"', modify
label define s1q15 5020816 `"Habani"', modify
label define s1q15 5020817 `"Simagahi"', modify
label define s1q15 5020818 `"Ware Island"', modify
label define s1q15 5020819 `"Bedauna"', modify
label define s1q15 5020820 `"Sideia"', modify
label define s1q15 5020821 `"Kuiaro"', modify
label define s1q15 5020822 `"Sekuku"', modify
label define s1q15 5020823 `"Sidudu"', modify
label define s1q15 5020901 `"Mwabua"', modify
label define s1q15 5020902 `"Narian"', modify
label define s1q15 5020903 `"Bwagaoia"', modify
label define s1q15 5020904 `"Hinauta"', modify
label define s1q15 5020905 `"Kaubwaga"', modify
label define s1q15 5020906 `"Boiou"', modify
label define s1q15 5020907 `"Siagara East"', modify
label define s1q15 5020908 `"Siagara West"', modify
label define s1q15 5020909 `"Gulewa"', modify
label define s1q15 5020910 `"East Liak"', modify
label define s1q15 5020911 `"West Liak"', modify
label define s1q15 5020912 `"Bagilina"', modify
label define s1q15 5020913 `"Ewena"', modify
label define s1q15 5020914 `"Ebora"', modify
label define s1q15 5020915 `"Bwagabwaga"', modify
label define s1q15 5020916 `"Awaibi"', modify
label define s1q15 5020917 `"Alhoga"', modify
label define s1q15 5020918 `"Eaus North"', modify
label define s1q15 5020919 `"Eaus South"', modify
label define s1q15 5020920 `"Gaibobo"', modify
label define s1q15 5020921 `"Kimuta"', modify
label define s1q15 5020922 `"West Panaeati"', modify
label define s1q15 5020923 `"East Panaeati"', modify
label define s1q15 5020924 `"Panapompom"', modify
label define s1q15 5020925 `"Brooker Island"', modify
label define s1q15 5020926 `"Motorina East"', modify
label define s1q15 5020927 `"Motorina West"', modify
label define s1q15 5020928 `"Bagaman"', modify
label define s1q15 5020929 `"Panaumala"', modify
label define s1q15 5020930 `"Baimatana"', modify
label define s1q15 5020931 `"Loba"', modify
label define s1q15 5020932 `"Bwana"', modify
label define s1q15 5021001 `"Sabara"', modify
label define s1q15 5021002 `"Grass Island"', modify
label define s1q15 5021003 `"Nimoa"', modify
label define s1q15 5021004 `"Western Point"', modify
label define s1q15 5021005 `"Griffin Point"', modify
label define s1q15 5021006 `"Rambuso"', modify
label define s1q15 5021007 `"Rehuwo"', modify
label define s1q15 5021008 `"Madawa"', modify
label define s1q15 5021009 `"Jelewaga"', modify
label define s1q15 5021010 `"Damunu"', modify
label define s1q15 5021011 `"Morpa"', modify
label define s1q15 5021012 `"Wulanga Bay"', modify
label define s1q15 5021013 `"Jinjo"', modify
label define s1q15 5021014 `"Abeleti"', modify
label define s1q15 5021015 `"N'jaru"', modify
label define s1q15 5021016 `"Buwo"', modify
label define s1q15 5021017 `"Pambwa / Saman"', modify
label define s1q15 5021101 `"Kulumadau"', modify
label define s1q15 5021102 `"Guasopa"', modify
label define s1q15 5021103 `"Wabununa"', modify
label define s1q15 5021104 `"Kavatana"', modify
label define s1q15 5021105 `"Kaurai"', modify
label define s1q15 5021106 `"Iwa"', modify
label define s1q15 5021107 `"Unumatana"', modify
label define s1q15 5021108 `"Budibudi"', modify
label define s1q15 5021109 `"Yanaba"', modify
label define s1q15 5021110 `"Gawa Island"', modify
label define s1q15 5021111 `"Kauwai"', modify
label define s1q15 5021112 `"Madau"', modify
label define s1q15 5021113 `"Dikoias"', modify
label define s1q15 5021114 `"Kwaiwata"', modify
label define s1q15 5021115 `"Muneiveyova"', modify
label define s1q15 5021116 `"Oyavata"', modify
label define s1q15 5021117 `"Alcester"', modify
label define s1q15 5031201 `"Kaibola"', modify
label define s1q15 5031202 `"Mwatawa"', modify
label define s1q15 5031203 `"Tubowada"', modify
label define s1q15 5031204 `"Dayagila"', modify
label define s1q15 5031205 `"Liluta"', modify
label define s1q15 5031206 `"Kwebwaga"', modify
label define s1q15 5031207 `"Omarakana"', modify
label define s1q15 5031208 `"Kabwaku"', modify
label define s1q15 5031209 `"Okaikoda"', modify
label define s1q15 5031210 `"Yalumgwa"', modify
label define s1q15 5031211 `"Kuruvitu"', modify
label define s1q15 5031212 `"Yalaka"', modify
label define s1q15 5031213 `"Wabutuma"', modify
label define s1q15 5031214 `"Bwetalu"', modify
label define s1q15 5031215 `"Gumilababa"', modify
label define s1q15 5031216 `"Kapwapu"', modify
label define s1q15 5031217 `"Kavataria"', modify
label define s1q15 5031218 `"Mulosaida"', modify
label define s1q15 5031219 `"Oyuveyova"', modify
label define s1q15 5031220 `"Tukwaukwa"', modify
label define s1q15 5031221 `"Okaiboma"', modify
label define s1q15 5031222 `"Ilalima"', modify
label define s1q15 5031223 `"Obulaku"', modify
label define s1q15 5031224 `"Sinaketa"', modify
label define s1q15 5031225 `"Loya"', modify
label define s1q15 5031226 `"Vakuta"', modify
label define s1q15 5031227 `"Kwumwagea"', modify
label define s1q15 5031228 `"Lalela"', modify
label define s1q15 5031229 `"Okabulula"', modify
label define s1q15 5031230 `"Kaduwaga"', modify
label define s1q15 5031231 `"Koma"', modify
label define s1q15 5031232 `"Kuyawa"', modify
label define s1q15 5031233 `"Simsimla"', modify
label define s1q15 5031301 `"Waibula"', modify
label define s1q15 5031302 `"Ufaufa"', modify
label define s1q15 5031303 `"Watuluma Upper"', modify
label define s1q15 5031304 `"Watuluma Lower"', modify
label define s1q15 5031305 `"Idakamenai"', modify
label define s1q15 5031306 `"Ulutuya"', modify
label define s1q15 5031307 `"Wakonai"', modify
label define s1q15 5031308 `"Vivigani"', modify
label define s1q15 5031309 `"Eweli"', modify
label define s1q15 5031310 `"Kalauna"', modify
label define s1q15 5031311 `"Belebele"', modify
label define s1q15 5031312 `"Mataita West"', modify
label define s1q15 5031313 `"Mataita East"', modify
label define s1q15 5031314 `"Faiava"', modify
label define s1q15 5031315 `"Ufu'ufu"', modify
label define s1q15 5031316 `"Bwadoga East"', modify
label define s1q15 5031317 `"Bwadoga West"', modify
label define s1q15 5031318 `"Wagifa"', modify
label define s1q15 5031319 `"Abolu"', modify
label define s1q15 5031320 `"Kilia"', modify
label define s1q15 5031321 `"Lauwela"', modify
label define s1q15 5031322 `"Awale"', modify
label define s1q15 5031323 `"Utalo"', modify
label define s1q15 5031324 `"Diodio"', modify
label define s1q15 5031325 `"Yauyaula"', modify
label define s1q15 5031326 `"Awaya"', modify
label define s1q15 5031327 `"Ibawana"', modify
label define s1q15 5031328 `"Kalimtabutabu"', modify
label define s1q15 5041401 `"Fayayana"', modify
label define s1q15 5041402 `"Ailuluai"', modify
label define s1q15 5041403 `"Ukeokeo"', modify
label define s1q15 5041404 `"Toagesi"', modify
label define s1q15 5041405 `"Igwageta"', modify
label define s1q15 5041406 `"Kukuya"', modify
label define s1q15 5041407 `"Ibwananiu"', modify
label define s1q15 5041408 `"Mapamoiwa"', modify
label define s1q15 5041409 `"Fagululu"', modify
label define s1q15 5041410 `"Iamalele South"', modify
label define s1q15 5041411 `"Iamalele North"', modify
label define s1q15 5041412 `"Gewata"', modify
label define s1q15 5041413 `"Saibutu"', modify
label define s1q15 5041414 `"Niubuo"', modify
label define s1q15 5041415 `"Ebadidi"', modify
label define s1q15 5041416 `"Tutubea"', modify
label define s1q15 5041417 `"Bwayobwayo"', modify
label define s1q15 5041418 `"Masimasi"', modify
label define s1q15 5041419 `"Gwabegwabe"', modify
label define s1q15 5041420 `"Atugamwana"', modify
label define s1q15 5041421 `"Agealuma"', modify
label define s1q15 5041422 `"Didiau"', modify
label define s1q15 5041423 `"Kalokalo"', modify
label define s1q15 5041424 `"Fatavi"', modify
label define s1q15 5041425 `"Wapolu"', modify
label define s1q15 5041501 `"Maiabari"', modify
label define s1q15 5041502 `"Bwakera"', modify
label define s1q15 5041503 `"Koruwea"', modify
label define s1q15 5041504 `"Io'o"', modify
label define s1q15 5041505 `"Taulu"', modify
label define s1q15 5041506 `"Sisiana"', modify
label define s1q15 5041507 `"Miadeba"', modify
label define s1q15 5041508 `"Darubia"', modify
label define s1q15 5041509 `"Kenaia"', modify
label define s1q15 5041510 `"Buduwagula"', modify
label define s1q15 5041511 `"Nade"', modify
label define s1q15 5041512 `"Sill'Ilugu"', modify
label define s1q15 5041513 `"Wesoiliwe"', modify
label define s1q15 5041514 `"Galibwa"', modify
label define s1q15 5041515 `"Neboluwa"', modify
label define s1q15 5041516 `"Salamo"', modify
label define s1q15 5041517 `"Gomwa"', modify
label define s1q15 5041518 `"Begasi"', modify
label define s1q15 5041519 `"Du'una"', modify
label define s1q15 5041520 `"Daguyala"', modify
label define s1q15 5041521 `"Deidei"', modify
label define s1q15 5041522 `"Bwaiowa"', modify
label define s1q15 5041523 `"Sawa'edi"', modify
label define s1q15 5041524 `"Waluma East"', modify
label define s1q15 5041525 `"Waluma West"', modify
label define s1q15 5041526 `"Sebutuya"', modify
label define s1q15 5041527 `"Momoawa"', modify
label define s1q15 5041528 `"Basima"', modify
label define s1q15 5041529 `"Urua"', modify
label define s1q15 5041530 `"Gameta"', modify
label define s1q15 5041531 `"Duduna"', modify
label define s1q15 5041532 `"Wadalei"', modify
label define s1q15 5041533 `"Bosalewa"', modify
label define s1q15 5041534 `"Gumawana"', modify
label define s1q15 5041535 `"Sanaroa"', modify
label define s1q15 5041601 `"Kalologea"', modify
label define s1q15 5041602 `"Sawatupwa"', modify
label define s1q15 5041603 `"Mwatebu"', modify
label define s1q15 5041604 `"Sawataatae"', modify
label define s1q15 5041605 `"Lomitawa"', modify
label define s1q15 5041606 `"Sipupu"', modify
label define s1q15 5041607 `"Wayoko"', modify
label define s1q15 5041608 `"Maudana"', modify
label define s1q15 5041609 `"Kwanauia"', modify
label define s1q15 5041610 `"Loboda"', modify
label define s1q15 5041611 `"Siausi"', modify
label define s1q15 5041612 `"Dawada"', modify
label define s1q15 5041613 `"Sigasiga"', modify
label define s1q15 5041614 `"Sapisapia"', modify
label define s1q15 5041615 `"Bihawa"', modify
label define s1q15 5041616 `"Somwadina"', modify
label define s1q15 5041617 `"Mwalakwasia"', modify
label define s1q15 5041618 `"Kasikasi"', modify
label define s1q15 5041619 `"Kumwalau"', modify
label define s1q15 5041620 `"Kalotau"', modify
label define s1q15 5041621 `"Barabara"', modify
label define s1q15 5041622 `"Bunama"', modify
label define s1q15 5041623 `"Gumali"', modify
label define s1q15 5041624 `"Isumayaumayau"', modify
label define s1q15 5041625 `"Pwanapwana"', modify
label define s1q15 5041626 `"Sibonai"', modify
label define s1q15 5041627 `"Bwasiyaiyai"', modify
label define s1q15 5041628 `"Kurada"', modify
label define s1q15 6010101 `"Sariri"', modify
label define s1q15 6010102 `"Gunimba"', modify
label define s1q15 6010103 `"Jegerakambo"', modify
label define s1q15 6010104 `"Emo"', modify
label define s1q15 6010105 `"Banderi"', modify
label define s1q15 6010106 `"Waiwa"', modify
label define s1q15 6010107 `"Beama"', modify
label define s1q15 6010108 `"Baberada"', modify
label define s1q15 6010109 `"Dombada"', modify
label define s1q15 6010110 `"Hanakiro"', modify
label define s1q15 6010111 `"Kararata"', modify
label define s1q15 6010112 `"Dobuduru"', modify
label define s1q15 6010113 `"Barisari"', modify
label define s1q15 6010114 `"Siremi"', modify
label define s1q15 6010115 `"Buna"', modify
label define s1q15 6010116 `"Killerton"', modify
label define s1q15 6010117 `"Otobefari"', modify
label define s1q15 6010118 `"Konje"', modify
label define s1q15 6010119 `"Kausada"', modify
label define s1q15 6010120 `"Jinanga"', modify
label define s1q15 6010121 `"Bakumbari"', modify
label define s1q15 6010122 `"Batari"', modify
label define s1q15 6010123 `"Oure"', modify
label define s1q15 6010124 `"Aure"', modify
label define s1q15 6010125 `"Dewatutu"', modify
label define s1q15 6010126 `"Bindari"', modify
label define s1q15 6010201 `"Kewansapsap"', modify
label define s1q15 6010202 `"Marua"', modify
label define s1q15 6010203 `"Uiaku"', modify
label define s1q15 6010204 `"Ganjiga"', modify
label define s1q15 6010205 `"Rainu"', modify
label define s1q15 6010206 `"Koreaf"', modify
label define s1q15 6010207 `"Ajoa"', modify
label define s1q15 6010208 `"Itoto"', modify
label define s1q15 6010209 `"Giriwa"', modify
label define s1q15 6010210 `"Managa"', modify
label define s1q15 6010211 `"Jebo"', modify
label define s1q15 6010212 `"Baga"', modify
label define s1q15 6010213 `"Kwave"', modify
label define s1q15 6010214 `"Sefoa"', modify
label define s1q15 6010215 `"Sinei"', modify
label define s1q15 6010216 `"Berebona 1 &amp; 2"', modify
label define s1q15 6010217 `"Ako"', modify
label define s1q15 6010221 `"Guruguru"', modify
label define s1q15 6010223 `"Gobe"', modify
label define s1q15 6010285 `"Tufi Govt. Station"', modify
label define s1q15 6010301 `"Yoivi"', modify
label define s1q15 6010302 `"Niniuri"', modify
label define s1q15 6010303 `"Kawowoki"', modify
label define s1q15 6010304 `"Kaura"', modify
label define s1q15 6010305 `"Siurani"', modify
label define s1q15 6010306 `"Kowena"', modify
label define s1q15 6010307 `"Dea"', modify
label define s1q15 6010308 `"Siribu"', modify
label define s1q15 6010309 `"Natanga"', modify
label define s1q15 6010310 `"Gora"', modify
label define s1q15 6010311 `"Tahama"', modify
label define s1q15 6010312 `"Umbuara"', modify
label define s1q15 6010313 `"Kokoro"', modify
label define s1q15 6010314 `"Ufia"', modify
label define s1q15 6010315 `"Toma"', modify
label define s1q15 6010316 `"Aiari"', modify
label define s1q15 6010317 `"Yaure"', modify
label define s1q15 6010325 `"Gorabuna"', modify
label define s1q15 6010406 `"Gewoto"', modify
label define s1q15 6010407 `"Sewa"', modify
label define s1q15 6010408 `"Isuga"', modify
label define s1q15 6010410 `"Sorovi"', modify
label define s1q15 6010411 `"East Embogo"', modify
label define s1q15 6010480 `"Popondetta Urban"', modify
label define s1q15 6010901 `"Namudi"', modify
label define s1q15 6010902 `"Sinua"', modify
label define s1q15 6010903 `"Moro"', modify
label define s1q15 6010904 `"Jari"', modify
label define s1q15 6010905 `"Tuturawaru/ Bibira No.2"', modify
label define s1q15 6010906 `"Safia"', modify
label define s1q15 6010907 `"Obea"', modify
label define s1q15 6010908 `"Foru"', modify
label define s1q15 6010909 `"Karisoa"', modify
label define s1q15 6010910 `"Kinjaki"', modify
label define s1q15 6010911 `"Embesa"', modify
label define s1q15 6010912 `"Koira"', modify
label define s1q15 6010913 `"Domara"', modify
label define s1q15 6020501 `"Asimba"', modify
label define s1q15 6020502 `"Kovelo"', modify
label define s1q15 6020504 `"Saga"', modify
label define s1q15 6020506 `"Iora Lss Blocks"', modify
label define s1q15 6020507 `"Kebara"', modify
label define s1q15 6020508 `"Abuari"', modify
label define s1q15 6020509 `"Alola"', modify
label define s1q15 6020510 `"Waju"', modify
label define s1q15 6020511 `"Hangiri"', modify
label define s1q15 6020512 `"Ambene"', modify
label define s1q15 6020513 `"Ilimo"', modify
label define s1q15 6020514 `"Hamara"', modify
label define s1q15 6020515 `"Ajeka"', modify
label define s1q15 6020516 `"Evasusu"', modify
label define s1q15 6020517 `"Asisi"', modify
label define s1q15 6020518 `"Sairope"', modify
label define s1q15 6020519 `"Putembo"', modify
label define s1q15 6020520 `"Asafa"', modify
label define s1q15 6020521 `"Wora"', modify
label define s1q15 6020522 `"Emo"', modify
label define s1q15 6020523 `"Awoma"', modify
label define s1q15 6020524 `"Kovio"', modify
label define s1q15 6020581 `"Kokoda Urban"', modify
label define s1q15 6020582 `"Mamba Urban"', modify
label define s1q15 6020601 `"New Warisota"', modify
label define s1q15 6020602 `"Hohorita"', modify
label define s1q15 6020603 `"Igora Oil Palm Blks"', modify
label define s1q15 6020604 `"Koipa"', modify
label define s1q15 6020605 `"Kiorota"', modify
label define s1q15 6020606 `"Barevoturu"', modify
label define s1q15 6020607 `"Kendata"', modify
label define s1q15 6020608 `"Duve"', modify
label define s1q15 6020609 `"Kongohambou"', modify
label define s1q15 6020610 `"Binduta"', modify
label define s1q15 6020611 `"Handarituru"', modify
label define s1q15 6020612 `"Awala"', modify
label define s1q15 6020613 `"Sui"', modify
label define s1q15 6020614 `"Boru"', modify
label define s1q15 6020615 `"Mumuni"', modify
label define s1q15 6020616 `"Koropata"', modify
label define s1q15 6020617 `"Sirembi"', modify
label define s1q15 6020618 `"Hungiri"', modify
label define s1q15 6020619 `"Sakita"', modify
label define s1q15 6020620 `"Papoga"', modify
label define s1q15 6020621 `"Ongoho"', modify
label define s1q15 6020622 `"Ehu"', modify
label define s1q15 6020623 `"Ahora &amp; Beuru"', modify
label define s1q15 6020624 `"West Ambogo (Sangara)"', modify
label define s1q15 6020625 `"Sangara 1"', modify
label define s1q15 6020626 `"Sangara 2"', modify
label define s1q15 6020627 `"Isivini"', modify
label define s1q15 6020628 `"Horau"', modify
label define s1q15 6020701 `"Huratan"', modify
label define s1q15 6020702 `"Oitatande"', modify
label define s1q15 6020703 `"Kikinonda"', modify
label define s1q15 6020704 `"Korisata"', modify
label define s1q15 6020705 `"Utukiari"', modify
label define s1q15 6020706 `"Kurereda"', modify
label define s1q15 6020707 `"Jino"', modify
label define s1q15 6020708 `"Sia"', modify
label define s1q15 6020709 `"Manau"', modify
label define s1q15 6020710 `"Deboin"', modify
label define s1q15 6020711 `"Kataure"', modify
label define s1q15 6020712 `"Tubi"', modify
label define s1q15 6020713 `"Aindi"', modify
label define s1q15 6020714 `"Nindewari"', modify
label define s1q15 6020715 `"Ewore"', modify
label define s1q15 6020716 `"Bovera"', modify
label define s1q15 6020717 `"Tave"', modify
label define s1q15 6020801 `"Pepeware"', modify
label define s1q15 6020802 `"Gobe"', modify
label define s1q15 6020803 `"Upupuro"', modify
label define s1q15 6020804 `"Ovasupu"', modify
label define s1q15 6020805 `"Oibo"', modify
label define s1q15 7010101 `"Molo"', modify
label define s1q15 7010102 `"Alia"', modify
label define s1q15 7010103 `"Morea 1"', modify
label define s1q15 7010104 `"Morea 2"', modify
label define s1q15 7010105 `"Pokale 1"', modify
label define s1q15 7010106 `"Pokale 2"', modify
label define s1q15 7010107 `"Apenda 1"', modify
label define s1q15 7010108 `"Apenda 2"', modify
label define s1q15 7010109 `"Mele 1"', modify
label define s1q15 7010110 `"Mele 2"', modify
label define s1q15 7010111 `"Kumiane"', modify
label define s1q15 7010112 `"Pondi"', modify
label define s1q15 7010113 `"Pangia Station"', modify
label define s1q15 7010114 `"Maia"', modify
label define s1q15 7010115 `"Kauwo 1"', modify
label define s1q15 7010116 `"Kauwo 2"', modify
label define s1q15 7010117 `"Kauwo 3"', modify
label define s1q15 7010118 `"Leka/Koiya"', modify
label define s1q15 7010119 `"Yunguli"', modify
label define s1q15 7010120 `"Tindua 1"', modify
label define s1q15 7010121 `"Tindua 2"', modify
label define s1q15 7010123 `"Walapape"', modify
label define s1q15 7010124 `"Walupo"', modify
label define s1q15 7010125 `"Walupoi"', modify
label define s1q15 7010126 `"Mondanda"', modify
label define s1q15 7010205 `"Yameyame"', modify
label define s1q15 7010206 `"Topopugl 1"', modify
label define s1q15 7010207 `"Topopugl 2"', modify
label define s1q15 7010208 `"Kendal 2"', modify
label define s1q15 7010210 `"Kendal 3"', modify
label define s1q15 7010282 `"Ialibu Station"', modify
label define s1q15 7010301 `"Kepiki 1"', modify
label define s1q15 7010302 `"Kepiki 2"', modify
label define s1q15 7010303 `"Wangai"', modify
label define s1q15 7010304 `"Yate"', modify
label define s1q15 7010305 `"Muli 1"', modify
label define s1q15 7010306 `"Muli 2"', modify
label define s1q15 7010307 `"Paibo"', modify
label define s1q15 7010308 `"Yarena"', modify
label define s1q15 7010309 `"Pale"', modify
label define s1q15 7010310 `"Mambi"', modify
label define s1q15 7010311 `"Munku 1"', modify
label define s1q15 7010312 `"Munku 2"', modify
label define s1q15 7010313 `"Makura 1"', modify
label define s1q15 7010314 `"Mugura 2"', modify
label define s1q15 7010315 `"Kirene"', modify
label define s1q15 7010316 `"Kumbeme 1"', modify
label define s1q15 7010317 `"Kumbeme 2"', modify
label define s1q15 7010318 `"Ponowi 1"', modify
label define s1q15 7010319 `"Ponowi 2"', modify
label define s1q15 7010320 `"Munkumapo"', modify
label define s1q15 7010321 `"Paibo 2"', modify
label define s1q15 7010322 `"Kirene 2"', modify
label define s1q15 7010323 `"Wangai 2"', modify
label define s1q15 7010324 `"Mambi 2"', modify
label define s1q15 7010325 `"Yarena 2"', modify
label define s1q15 7010326 `"Mungumapu 2"', modify
label define s1q15 7010328 `"Pale 2"', modify
label define s1q15 7010401 `"Poloko 2"', modify
label define s1q15 7010402 `"Poloko 1"', modify
label define s1q15 7010403 `"Borona"', modify
label define s1q15 7010404 `"Koiyapu"', modify
label define s1q15 7010405 `"Poleya"', modify
label define s1q15 7010406 `"Iaro 1"', modify
label define s1q15 7010407 `"Iaro 2"', modify
label define s1q15 7010408 `"Kalane"', modify
label define s1q15 7010409 `"Kaluwe 1"', modify
label define s1q15 7010410 `"Kaluwe 2"', modify
label define s1q15 7010411 `"Weriko"', modify
label define s1q15 7010412 `"Maubinin"', modify
label define s1q15 7010413 `"Kerapali"', modify
label define s1q15 7010414 `"Tunda"', modify
label define s1q15 7010415 `"Timbikene 1"', modify
label define s1q15 7010416 `"Timbikene 2"', modify
label define s1q15 7010417 `"Pubi"', modify
label define s1q15 7010418 `"Lawe"', modify
label define s1q15 7010419 `"Timbari 1"', modify
label define s1q15 7010420 `"Timbari 2"', modify
label define s1q15 7010421 `"Wanu"', modify
label define s1q15 7010422 `"Marapini"', modify
label define s1q15 7010423 `"Undiyapu"', modify
label define s1q15 7010424 `"Yakiliyapu"', modify
label define s1q15 7010425 `"Yoka"', modify
label define s1q15 7010426 `"Kuabini"', modify
label define s1q15 7010427 `"Noiya"', modify
label define s1q15 7010428 `"Taguru"', modify
label define s1q15 7010434 `"Kengerene"', modify
label define s1q15 7020501 `"Kalipinie"', modify
label define s1q15 7020502 `"Kou"', modify
label define s1q15 7020503 `"Kero 1"', modify
label define s1q15 7020504 `"Kero 2"', modify
label define s1q15 7020505 `"Poneglama"', modify
label define s1q15 7020506 `"Kongibugl 1"', modify
label define s1q15 7020507 `"Kongibugl 2"', modify
label define s1q15 7020508 `"Bimbene 1"', modify
label define s1q15 7020509 `"Bibine 2"', modify
label define s1q15 7020510 `"Kapoglpopilie"', modify
label define s1q15 7020511 `"Yombi 1"', modify
label define s1q15 7020512 `"Yawalangil 1"', modify
label define s1q15 7020513 `"Topel/Kopri"', modify
label define s1q15 7020514 `"Lepera"', modify
label define s1q15 7020515 `"Pakulge"', modify
label define s1q15 7020516 `"Yawalangil 2"', modify
label define s1q15 7020518 `"Kendal 1"', modify
label define s1q15 7020520 `"Iombi 2"', modify
label define s1q15 7020521 `"Kalano"', modify
label define s1q15 7020522 `"Maral"', modify
label define s1q15 7020601 `"Kisenapoi"', modify
label define s1q15 7020602 `"Moka 1"', modify
label define s1q15 7020604 `"Kumunge"', modify
label define s1q15 7020605 `"Beechwood 1"', modify
label define s1q15 7020606 `"Koropangi"', modify
label define s1q15 7020607 `"Beechwood 2"', modify
label define s1q15 7020608 `"Kume 1"', modify
label define s1q15 7020609 `"Kume 2"', modify
label define s1q15 7020610 `"Tona"', modify
label define s1q15 7020611 `"Piambil 1"', modify
label define s1q15 7020612 `"Piambil 2"', modify
label define s1q15 7020613 `"Parare 1"', modify
label define s1q15 7020614 `"Papare 1/Nagop 1"', modify
label define s1q15 7020615 `"Papare 2/ Nagop 2"', modify
label define s1q15 7020616 `"Orei 2"', modify
label define s1q15 7020617 `"Moka 2"', modify
label define s1q15 7020618 `"Kisenapoi 2/Puglupiri"', modify
label define s1q15 7020619 `"Tukupangi"', modify
label define s1q15 7020701 `"Endowa"', modify
label define s1q15 7020702 `"Tepe/Eskamb"', modify
label define s1q15 7020703 `"Sumia 1"', modify
label define s1q15 7020704 `"Sumia 2"', modify
label define s1q15 7020705 `"Yore 1"', modify
label define s1q15 7020706 `"Yore 2"', modify
label define s1q15 7020707 `"Tutam"', modify
label define s1q15 7020708 `"Yebi 1"', modify
label define s1q15 7020709 `"Yebi 2"', modify
label define s1q15 7020710 `"Aisaisa"', modify
label define s1q15 7020711 `"Pundia/Limbiali"', modify
label define s1q15 7020712 `"Megi"', modify
label define s1q15 7020713 `"Onne"', modify
label define s1q15 7020715 `"Yebi 3"', modify
label define s1q15 7020716 `"Omai"', modify
label define s1q15 7020717 `"Pororo"', modify
label define s1q15 7020718 `"Mil/Warip"', modify
label define s1q15 7020719 `"Sumia 3"', modify
label define s1q15 7020720 `"Yaria"', modify
label define s1q15 7020721 `"Kiberu"', modify
label define s1q15 7020722 `"Yaken 1"', modify
label define s1q15 7020723 `"Bui-iebi"', modify
label define s1q15 7020724 `"Lumbi/Tutam"', modify
label define s1q15 7020725 `"Una/Kos"', modify
label define s1q15 7020726 `"Pinj"', modify
label define s1q15 7030801 `"Galu"', modify
label define s1q15 7030802 `"Tiripi"', modify
label define s1q15 7030803 `"Batri 1"', modify
label define s1q15 7030804 `"Batri 2"', modify
label define s1q15 7030805 `"Iamorubi"', modify
label define s1q15 7030806 `"Erave Station"', modify
label define s1q15 7030807 `"Koyari"', modify
label define s1q15 7030808 `"Tsimberigi (Tiabili)"', modify
label define s1q15 7030809 `"Kerabi"', modify
label define s1q15 7030810 `"Barowai"', modify
label define s1q15 7030811 `"Tiri"', modify
label define s1q15 7030812 `"Waragu"', modify
label define s1q15 7030813 `"Waposali"', modify
label define s1q15 7030814 `"Kele"', modify
label define s1q15 7030815 `"Puputau"', modify
label define s1q15 7030816 `"Sirigi"', modify
label define s1q15 7030817 `"Sopisa"', modify
label define s1q15 7030818 `"Menekiri"', modify
label define s1q15 7030819 `"Marorogo"', modify
label define s1q15 7030820 `"Waro"', modify
label define s1q15 7030821 `"Yanguli 1"', modify
label define s1q15 7030822 `"Yanguli 2"', modify
label define s1q15 7030823 `"Pawabi 1"', modify
label define s1q15 7030824 `"Pawabi 2"', modify
label define s1q15 7030825 `"Sau"', modify
label define s1q15 7030826 `"Kati"', modify
label define s1q15 7030827 `"Pawale"', modify
label define s1q15 7030828 `"Niae"', modify
label define s1q15 7030901 `"Alopea"', modify
label define s1q15 7030902 `"Aboma"', modify
label define s1q15 7030903 `"Kagua Station"', modify
label define s1q15 7030904 `"Karia(Aliya)"', modify
label define s1q15 7030905 `"Katiloma"', modify
label define s1q15 7030906 `"Kira"', modify
label define s1q15 7030907 `"Koalilombo"', modify
label define s1q15 7030908 `"Andari"', modify
label define s1q15 7030909 `"Mapuanda"', modify
label define s1q15 7030910 `"Marili"', modify
label define s1q15 7030911 `"Mendo"', modify
label define s1q15 7030912 `"Mungaro"', modify
label define s1q15 7030913 `"Pawabi"', modify
label define s1q15 7030914 `"Porane"', modify
label define s1q15 7030915 `"Raku"', modify
label define s1q15 7030916 `"Rogoma"', modify
label define s1q15 7030917 `"Rongka"', modify
label define s1q15 7030918 `"Rumbalere"', modify
label define s1q15 7030919 `"Sumbura"', modify
label define s1q15 7030920 `"Wakiapanda"', modify
label define s1q15 7030921 `"Tulire"', modify
label define s1q15 7030922 `"Yalu"', modify
label define s1q15 7030923 `"Yango"', modify
label define s1q15 7030924 `"Yame"', modify
label define s1q15 7031001 `"Epapini"', modify
label define s1q15 7031002 `"Ita"', modify
label define s1q15 7031003 `"Kalawida"', modify
label define s1q15 7031004 `"Kaporoi"', modify
label define s1q15 7031005 `"Karanda 1"', modify
label define s1q15 7031006 `"Karanda 2"', modify
label define s1q15 7031007 `"Karavere"', modify
label define s1q15 7031008 `"Kilipini 1"', modify
label define s1q15 7031009 `"Kola"', modify
label define s1q15 7031010 `"Kuwi"', modify
label define s1q15 7031011 `"Lapoko"', modify
label define s1q15 7031012 `"Tindane/Kolopi"', modify
label define s1q15 7031013 `"Tulupari"', modify
label define s1q15 7031014 `"Agu Limba"', modify
label define s1q15 7031015 `"Mapiro 1"', modify
label define s1q15 7031016 `"Mapiro 2"', modify
label define s1q15 7031017 `"Kupia"', modify
label define s1q15 7061801 `"Puinj 1"', modify
label define s1q15 7061802 `"Puinj 2"', modify
label define s1q15 7061803 `"Map 1"', modify
label define s1q15 7061804 `"Map 2"', modify
label define s1q15 7061805 `"Wambip 1"', modify
label define s1q15 7061806 `"Imila"', modify
label define s1q15 7061807 `"Melant"', modify
label define s1q15 7061809 `"Humbura"', modify
label define s1q15 7061810 `"Tulum 1"', modify
label define s1q15 7061811 `"Tulum 2"', modify
label define s1q15 7061812 `"Posulim"', modify
label define s1q15 7061813 `"Pembi"', modify
label define s1q15 7061814 `"kusi"', modify
label define s1q15 7061815 `"Pingirip"', modify
label define s1q15 7061816 `"Semb Marep 1"', modify
label define s1q15 7061817 `"Marep 2"', modify
label define s1q15 7061818 `"Paip"', modify
label define s1q15 7061819 `"Mulim"', modify
label define s1q15 7061820 `"Heip"', modify
label define s1q15 7061821 `"Bela"', modify
label define s1q15 7061822 `"Kamberep"', modify
label define s1q15 7061823 `"Was"', modify
label define s1q15 7061901 `"Tugup/Tukup"', modify
label define s1q15 7061902 `"Komp"', modify
label define s1q15 7061903 `"Tugup 1"', modify
label define s1q15 7061904 `"Kip 1"', modify
label define s1q15 7061905 `"Kip 2"', modify
label define s1q15 7061906 `"Tumia"', modify
label define s1q15 7061907 `"Munihu Station"', modify
label define s1q15 7061908 `"Maip 1"', modify
label define s1q15 7061909 `"Kuianda"', modify
label define s1q15 7061910 `"Soba 1"', modify
label define s1q15 7061911 `"Soba 2"', modify
label define s1q15 7061912 `"Nol"', modify
label define s1q15 7061913 `"Injet"', modify
label define s1q15 7061914 `"Tubip 2"', modify
label define s1q15 7061915 `"Kema"', modify
label define s1q15 7061916 `"Nengia"', modify
label define s1q15 7061917 `"Imilhoma"', modify
label define s1q15 7061918 `"Wariba"', modify
label define s1q15 7061919 `"Marara"', modify
label define s1q15 7061920 `"Sol"', modify
label define s1q15 7061921 `"Honda"', modify
label define s1q15 7061922 `"Monta"', modify
label define s1q15 7061923 `"Maip 2"', modify
label define s1q15 7061924 `"Soba"', modify
label define s1q15 7061925 `"Mariste"', modify
label define s1q15 7061926 `"Waip"', modify
label define s1q15 7062006 `"Teta"', modify
label define s1q15 7062007 `"Wakwak/Umbimi"', modify
label define s1q15 7062008 `"Longo/Kave"', modify
label define s1q15 7062009 `"Mes Wa"', modify
label define s1q15 7062010 `"Kumin/Kambiakip"', modify
label define s1q15 7062011 `"Tubiri"', modify
label define s1q15 7062012 `"Poromanda/Unjamap"', modify
label define s1q15 7062013 `"Tente 1"', modify
label define s1q15 7062014 `"Tente 2"', modify
label define s1q15 7062081 `"Mendi Town"', modify
label define s1q15 7062101 `"Abua 1"', modify
label define s1q15 7062102 `"Abua 2"', modify
label define s1q15 7062103 `"Pongai"', modify
label define s1q15 7062104 `"Wagia"', modify
label define s1q15 7062105 `"Koen"', modify
label define s1q15 7062106 `"Enep/Dimifa"', modify
label define s1q15 7062107 `"Kuma 1"', modify
label define s1q15 7062108 `"Kundaga"', modify
label define s1q15 7062109 `"Birop 1"', modify
label define s1q15 7062110 `"Birop 2"', modify
label define s1q15 7062111 `"Birop 3"', modify
label define s1q15 7062112 `"Karel 1"', modify
label define s1q15 7062113 `"Karel 2"', modify
label define s1q15 7062114 `"Kuma 2"', modify
label define s1q15 7062115 `"Egari"', modify
label define s1q15 7062116 `"Mogol"', modify
label define s1q15 7062117 `"Kelta"', modify
label define s1q15 7062118 `"Nene"', modify
label define s1q15 7062119 `"Abua 3"', modify
label define s1q15 7062120 `"Mungura"', modify
label define s1q15 7062122 `"Kambai 1"', modify
label define s1q15 7062123 `"Kambai 2"', modify
label define s1q15 7062124 `"Waparaga"', modify
label define s1q15 7062125 `"Komia 1"', modify
label define s1q15 7062126 `"Komia 2"', modify
label define s1q15 7072201 `"Dugubali"', modify
label define s1q15 7072202 `"Gena'abo"', modify
label define s1q15 7072203 `"Damayu"', modify
label define s1q15 7072204 `"Irika"', modify
label define s1q15 7072205 `"Harabiyu"', modify
label define s1q15 7072206 `"Herebo"', modify
label define s1q15 7072207 `"Inu"', modify
label define s1q15 7072208 `"Gesege"', modify
label define s1q15 7072209 `"Iorogobayu"', modify
label define s1q15 7072210 `"Manu/Ward"', modify
label define s1q15 7072211 `"Gobe"', modify
label define s1q15 7072212 `"Hidinihia"', modify
label define s1q15 7072213 `"Fiwaga"', modify
label define s1q15 7072214 `"Tugiri"', modify
label define s1q15 7072215 `"Kafa"', modify
label define s1q15 7072216 `"Yalanda"', modify
label define s1q15 7072217 `"Sisibia"', modify
label define s1q15 7072218 `"Baguale"', modify
label define s1q15 7072301 `"Ludesa"', modify
label define s1q15 7072302 `"Bona"', modify
label define s1q15 7072303 `"Waragu"', modify
label define s1q15 7072304 `"Bobole"', modify
label define s1q15 7072305 `"Filisado"', modify
label define s1q15 7072306 `"Dodomona"', modify
label define s1q15 7072307 `"Banisa"', modify
label define s1q15 7072308 `"Wanagesa"', modify
label define s1q15 7072309 `"Fogomayu"', modify
label define s1q15 7072310 `"Musula"', modify
label define s1q15 7072311 `"Lake Campbell"', modify
label define s1q15 7072312 `"Gunigamo"', modify
label define s1q15 7072313 `"Igiribisado"', modify
label define s1q15 7072402 `"Uba No. 12"', modify
label define s1q15 7072404 `"Embi 2"', modify
label define s1q15 7072405 `"Pomberel 1"', modify
label define s1q15 7072406 `"Pomberel 2"', modify
label define s1q15 7072407 `"Tapua 13"', modify
label define s1q15 7072408 `"Tapua 14"', modify
label define s1q15 7072410 `"Askam 2"', modify
label define s1q15 7072411 `"Askam 1"', modify
label define s1q15 7072413 `"Tegipo 2"', modify
label define s1q15 7072414 `"Enjua 1"', modify
label define s1q15 7072415 `"Enjua 2"', modify
label define s1q15 7072417 `"Hulal 2"', modify
label define s1q15 7072418 `"Pinja 1"', modify
label define s1q15 7072419 `"Pinja 2"', modify
label define s1q15 7072421 `"Semin 2"', modify
label define s1q15 7072501 `"Soi"', modify
label define s1q15 7072502 `"Nipa H/School"', modify
label define s1q15 7072503 `"Haralinja"', modify
label define s1q15 7072504 `"Almanda 1"', modify
label define s1q15 7072505 `"Almanda 2"', modify
label define s1q15 7072506 `"Sesenda 2"', modify
label define s1q15 7072507 `"Sesenda 1"', modify
label define s1q15 7072508 `"Soi'l 2"', modify
label define s1q15 7072509 `"Shumbi 2"', modify
label define s1q15 7072510 `"Shumbi 1"', modify
label define s1q15 7072511 `"Ebil 2"', modify
label define s1q15 7072512 `"Ebil 1"', modify
label define s1q15 7072513 `"Eganda 3"', modify
label define s1q15 7072514 `"Erepi"', modify
label define s1q15 7072515 `"Ungubi 2"', modify
label define s1q15 7072516 `"Egenda 2"', modify
label define s1q15 7072517 `"Emb"', modify
label define s1q15 7072518 `"Suma 1"', modify
label define s1q15 7072519 `"Suma 2"', modify
label define s1q15 7072520 `"Hepinja 1 &amp; 16"', modify
label define s1q15 7072521 `"Poiya 7"', modify
label define s1q15 7072522 `"Ingin 2"', modify
label define s1q15 7072523 `"Ingin 1"', modify
label define s1q15 7072524 `"Merep"', modify
label define s1q15 7072525 `"Erep 5"', modify
label define s1q15 7072526 `"Tupip"', modify
label define s1q15 7072527 `"Poiya 6"', modify
label define s1q15 7072528 `"Nipa Station"', modify
label define s1q15 7072529 `"Ungubi 1"', modify
label define s1q15 7072530 `"Egenda 1"', modify
label define s1q15 7072531 `"Pulim 3"', modify
label define s1q15 7072532 `"Pulim 2"', modify
label define s1q15 7072533 `"Pulim 1"', modify
label define s1q15 7072534 `"Kware 2"', modify
label define s1q15 7072535 `"Kware 1"', modify
label define s1q15 7072536 `"Komea 2"', modify
label define s1q15 7072537 `"Komea 1"', modify
label define s1q15 7072538 `"Kombela"', modify
label define s1q15 7072539 `"Injip 2"', modify
label define s1q15 7072540 `"Injip 1"', modify
label define s1q15 7072601 `"Kongu"', modify
label define s1q15 7072602 `"Tindom 2"', modify
label define s1q15 7072603 `"Mondisarep"', modify
label define s1q15 7072604 `"Kar"', modify
label define s1q15 7072605 `"Utupia"', modify
label define s1q15 7072606 `"Undu Kopa"', modify
label define s1q15 7072607 `"Farata"', modify
label define s1q15 7072608 `"Kusa"', modify
label define s1q15 7072609 `"Det"', modify
label define s1q15 7072610 `"Onja-Rundu"', modify
label define s1q15 7072611 `"Waramesa"', modify
label define s1q15 7072612 `"ombadi"', modify
label define s1q15 7072613 `"Kapit/Kum 11"', modify
label define s1q15 7072614 `"Purtre/Kum 12"', modify
label define s1q15 7072615 `"Wanga"', modify
label define s1q15 7072616 `"Mato"', modify
label define s1q15 7072617 `"Nenja"', modify
label define s1q15 7072618 `"Poroma Station"', modify
label define s1q15 7072619 `"Kupipi"', modify
label define s1q15 7072620 `"Poroma"', modify
label define s1q15 7072621 `"Toiwaro"', modify
label define s1q15 7072622 `"Tamenda"', modify
label define s1q15 7072623 `"Kunjulu"', modify
label define s1q15 8010101 `"Weri"', modify
label define s1q15 8010102 `"Mumunt"', modify
label define s1q15 8010103 `"Iuripaka"', modify
label define s1q15 8010104 `"Supi"', modify
label define s1q15 8010105 `"Aluwaip"', modify
label define s1q15 8010106 `"Gini"', modify
label define s1q15 8010107 `"Komborosa"', modify
label define s1q15 8010108 `"Imali (Pindata)"', modify
label define s1q15 8010109 `"Pindaka"', modify
label define s1q15 8010110 `"Pura"', modify
label define s1q15 8010111 `"Kambia"', modify
label define s1q15 8010112 `"Koropa"', modify
label define s1q15 8010113 `"Lagalap No.1"', modify
label define s1q15 8010114 `"Lakalap No.2"', modify
label define s1q15 8010115 `"Winjap No.1"', modify
label define s1q15 8010116 `"Winjap No.2"', modify
label define s1q15 8010117 `"Lawe"', modify
label define s1q15 8010118 `"Muyen"', modify
label define s1q15 8010119 `"Warabim No.1"', modify
label define s1q15 8010120 `"Warabim No.2"', modify
label define s1q15 8010121 `"Teteres"', modify
label define s1q15 8010122 `"Yapum"', modify
label define s1q15 8010123 `"Murip"', modify
label define s1q15 8010124 `"Lakis"', modify
label define s1q15 8010125 `"Lyumbi Island"', modify
label define s1q15 8010126 `"Porgeramanda"', modify
label define s1q15 8010127 `"Kokas"', modify
label define s1q15 8010128 `"Rugutengesa"', modify
label define s1q15 8010129 `"Kandep Stn"', modify
label define s1q15 8010130 `"Sawi"', modify
label define s1q15 8010131 `"Werit 2"', modify
label define s1q15 8010134 `"Tinjipak (Supi No.2)"', modify
label define s1q15 8010136 `"Kondo (Kombolos No.2)"', modify
label define s1q15 8010138 `"Kalimang (Pindak 2)"', modify
label define s1q15 8010142 `"Tarapis"', modify
label define s1q15 8010144 `"Lawe 2"', modify
label define s1q15 8010145 `"Kemau Tesres"', modify
label define s1q15 8010146 `"Kiakau Murip 2"', modify
label define s1q15 8010147 `"Keso"', modify
label define s1q15 8010149 `"Nangulam Lungutenges 2"', modify
label define s1q15 8010201 `"Yumbis"', modify
label define s1q15 8010202 `"Karekare"', modify
label define s1q15 8010203 `"Longap"', modify
label define s1q15 8010204 `"Mamal"', modify
label define s1q15 8010205 `"Peliyanjak"', modify
label define s1q15 8010206 `"Porokale"', modify
label define s1q15 8010207 `"Titengis"', modify
label define s1q15 8010208 `"Kitali"', modify
label define s1q15 8010209 `"Kumbanda"', modify
label define s1q15 8010210 `"Sitindak"', modify
label define s1q15 8010211 `"Kuikale"', modify
label define s1q15 8010212 `"Andokoe"', modify
label define s1q15 8010213 `"Bioko"', modify
label define s1q15 8010214 `"Imapiak"', modify
label define s1q15 8010215 `"Kanean"', modify
label define s1q15 8010216 `"Kinduli"', modify
label define s1q15 8010217 `"Laguni"', modify
label define s1q15 8010218 `"Maru"', modify
label define s1q15 8010219 `"Rumbipak"', modify
label define s1q15 8010220 `"Titip"', modify
label define s1q15 8010221 `"Nerep"', modify
label define s1q15 8010222 `"Waip"', modify
label define s1q15 8010223 `"Kondaka"', modify
label define s1q15 8020301 `"Par"', modify
label define s1q15 8020302 `"Lakapos"', modify
label define s1q15 8020303 `"Yampu"', modify
label define s1q15 8020304 `"Tialipos"', modify
label define s1q15 8020305 `"Aiametes"', modify
label define s1q15 8020306 `"Talemanda"', modify
label define s1q15 8020307 `"Palimbi"', modify
label define s1q15 8020308 `"Pandai"', modify
label define s1q15 8020309 `"Kasi"', modify
label define s1q15 8020310 `"Lakui"', modify
label define s1q15 8020311 `"Lakamanda"', modify
label define s1q15 8020312 `"Sikiro"', modify
label define s1q15 8020313 `"Sikiro Catholic Mission"', modify
label define s1q15 8020314 `"Anditale 1"', modify
label define s1q15 8020315 `"Anditale (2)"', modify
label define s1q15 8020316 `"Omain"', modify
label define s1q15 8020317 `"Monokam"', modify
label define s1q15 8020318 `"Tongem"', modify
label define s1q15 8020319 `"Kupin"', modify
label define s1q15 8020320 `"Kanomares"', modify
label define s1q15 8020321 `"Kambus"', modify
label define s1q15 8020322 `"Londor"', modify
label define s1q15 8020323 `"Elakale"', modify
label define s1q15 8020324 `"Penei (Lailam)"', modify
label define s1q15 8020325 `"Yarulama"', modify
label define s1q15 8020401 `"Silim"', modify
label define s1q15 8020402 `"Birip"', modify
label define s1q15 8020403 `"Wapai"', modify
label define s1q15 8020404 `"Sauanda"', modify
label define s1q15 8020405 `"Aiyulites"', modify
label define s1q15 8020406 `"Pomanda"', modify
label define s1q15 8020407 `"Kipilimanda"', modify
label define s1q15 8020408 `"Kompiam Stat."', modify
label define s1q15 8020409 `"Imbilik"', modify
label define s1q15 8020410 `"Kaipures"', modify
label define s1q15 8020411 `"Waibukam/Waipukam"', modify
label define s1q15 8020412 `"Kaindan"', modify
label define s1q15 8020413 `"Winikos"', modify
label define s1q15 8020414 `"Laiagam"', modify
label define s1q15 8020415 `"Yamanda"', modify
label define s1q15 8020416 `"Lingenas/Lengenas"', modify
label define s1q15 8020417 `"Rum"', modify
label define s1q15 8020418 `"Paip"', modify
label define s1q15 8020419 `"Pagalilyam"', modify
label define s1q15 8020420 `"Aperas"', modify
label define s1q15 8020421 `"Kiokai"', modify
label define s1q15 8020422 `"Liap"', modify
label define s1q15 8020423 `"Ipmauanda"', modify
label define s1q15 8020424 `"Lapalama"', modify
label define s1q15 8020425 `"Lyiamanda"', modify
label define s1q15 8020426 `"Rudisau"', modify
label define s1q15 8020427 `"Lailam No. 1"', modify
label define s1q15 8020428 `"Keman"', modify
label define s1q15 8020429 `"Paimanda"', modify
label define s1q15 8020430 `"pulipas"', modify
label define s1q15 8020431 `"Alakul"', modify
label define s1q15 8020432 `"Kaimas"', modify
label define s1q15 8020433 `"Yaumanda"', modify
label define s1q15 8020434 `"Samaremanda"', modify
label define s1q15 8020435 `"Yawalimanda"', modify
label define s1q15 8020436 `"Aipanda"', modify
label define s1q15 8020437 `"Amaimal"', modify
label define s1q15 8020438 `"Makale"', modify
label define s1q15 8020501 `"Yengis"', modify
label define s1q15 8020502 `"Saina"', modify
label define s1q15 8020503 `"Kenailama"', modify
label define s1q15 8020504 `"Mulale"', modify
label define s1q15 8020505 `"Warabul"', modify
label define s1q15 8020506 `"Pulukulama"', modify
label define s1q15 8020507 `"Pumean"', modify
label define s1q15 8020508 `"Kapumanda"', modify
label define s1q15 8020509 `"Mengao"', modify
label define s1q15 8020510 `"Mosop"', modify
label define s1q15 8020511 `"Yambaitok"', modify
label define s1q15 8020512 `"Kopaipalo"', modify
label define s1q15 8020513 `"Olimoli"', modify
label define s1q15 8020514 `"Elem"', modify
label define s1q15 8030601 `"Malale"', modify
label define s1q15 8030603 `"Kembos"', modify
label define s1q15 8030604 `"Komaip"', modify
label define s1q15 8030605 `"Wanepos"', modify
label define s1q15 8030606 `"Takuup"', modify
label define s1q15 8030607 `"Kasap"', modify
label define s1q15 8030608 `"Yangiyangi"', modify
label define s1q15 8030609 `"Kindarep"', modify
label define s1q15 8030610 `"Yakenda"', modify
label define s1q15 8030611 `"Keriapaka"', modify
label define s1q15 8030612 `"Aiyak (Aiyaka)"', modify
label define s1q15 8030613 `"Ipai"', modify
label define s1q15 8030614 `"Lyonge"', modify
label define s1q15 8030615 `"Paip"', modify
label define s1q15 8030616 `"Liop"', modify
label define s1q15 8030617 `"Yaki Due"', modify
label define s1q15 8030618 `"Sirunki"', modify
label define s1q15 8030619 `"Yailingis"', modify
label define s1q15 8030620 `"Kaipare"', modify
label define s1q15 8030621 `"Pore"', modify
label define s1q15 8030622 `"Tukusenda (Tukisenta)"', modify
label define s1q15 8030623 `"Nagulama"', modify
label define s1q15 8030624 `"Yomondi"', modify
label define s1q15 8030625 `"Kusi"', modify
label define s1q15 8030626 `"Paindako"', modify
label define s1q15 8030627 `"Kulita"', modify
label define s1q15 8030628 `"Watali"', modify
label define s1q15 8030629 `"Pipingus"', modify
label define s1q15 8030630 `"Kuimas"', modify
label define s1q15 8030681 `"Laiagam Urban"', modify
label define s1q15 8030701 `"Tumudane"', modify
label define s1q15 8030702 `"Walya"', modify
label define s1q15 8030703 `"Yeim"', modify
label define s1q15 8030704 `"Yalum"', modify
label define s1q15 8030705 `"Tombaip"', modify
label define s1q15 8030706 `"Rumbapres"', modify
label define s1q15 8030707 `"Yambali"', modify
label define s1q15 8030708 `"Muritaka"', modify
label define s1q15 8030709 `"Torenam"', modify
label define s1q15 8030710 `"Malaumanda"', modify
label define s1q15 8030711 `"Laku"', modify
label define s1q15 8030712 `"Tokom (Winjak)"', modify
label define s1q15 8030713 `"Lemong/Poreak"', modify
label define s1q15 8030715 `"Pokolip"', modify
label define s1q15 8030716 `"Yuyango"', modify
label define s1q15 8030717 `"Puaipak"', modify
label define s1q15 8030718 `"Paitengis"', modify
label define s1q15 8030719 `"Ipalopa"', modify
label define s1q15 8030801 `"Aspringa"', modify
label define s1q15 8030802 `"Bealo"', modify
label define s1q15 8030803 `"Ingalep"', modify
label define s1q15 8030804 `"Kolombi"', modify
label define s1q15 8030805 `"Waimalama"', modify
label define s1q15 8030806 `"Kamanga"', modify
label define s1q15 8030807 `"Tagoba"', modify
label define s1q15 8030808 `"Toronga"', modify
label define s1q15 8030809 `"Andita"', modify
label define s1q15 8030810 `"Kanjawi"', modify
label define s1q15 8030811 `"Mandukale"', modify
label define s1q15 8030812 `"Papake"', modify
label define s1q15 8030813 `"Mt. Kare"', modify
label define s1q15 8030815 `"Paiela Station"', modify
label define s1q15 8030816 `"Waiyalima"', modify
label define s1q15 8030901 `"Anowae"', modify
label define s1q15 8030902 `"Mugalep"', modify
label define s1q15 8030903 `"Apalaka"', modify
label define s1q15 8030904 `"Yuyan"', modify
label define s1q15 8030905 `"Politika"', modify
label define s1q15 8030906 `"Paiyam"', modify
label define s1q15 8030907 `"Palipaka"', modify
label define s1q15 8030908 `"Kairik"', modify
label define s1q15 8030909 `"Tipinini"', modify
label define s1q15 8030911 `"Yomodaka"', modify
label define s1q15 8030912 `"Yanjakali"', modify
label define s1q15 8030913 `"Nekeyanda"', modify
label define s1q15 8030914 `"Yaparep"', modify
label define s1q15 8030915 `"Yarik"', modify
label define s1q15 8030916 `"Pandami (Kairik)"', modify
label define s1q15 8030918 `"Taipoko"', modify
label define s1q15 8030983 `"Porgera Urban"', modify
label define s1q15 8030984 `"Paiam Town"', modify
label define s1q15 8031501 `"Kinapulama"', modify
label define s1q15 8031502 `"Yokonda"', modify
label define s1q15 8031503 `"Tupangus"', modify
label define s1q15 8031504 `"Porgeras"', modify
label define s1q15 8031505 `"Yangil"', modify
label define s1q15 8031506 `"Kailam"', modify
label define s1q15 8031507 `"Landelam"', modify
label define s1q15 8031508 `"Piyakain"', modify
label define s1q15 8031509 `"Tumbiop"', modify
label define s1q15 8031510 `"Kanamanda"', modify
label define s1q15 8031511 `"Kepelam"', modify
label define s1q15 8031512 `"Mapomanda"', modify
label define s1q15 8031513 `"Papayuku"', modify
label define s1q15 8031514 `"Kipos"', modify
label define s1q15 8031515 `"Pulukus"', modify
label define s1q15 8031516 `"Kanak"', modify
label define s1q15 8031517 `"Yango"', modify
label define s1q15 8031518 `"Tendep"', modify
label define s1q15 8031519 `"Lyamala"', modify
label define s1q15 8041080 `"Wabag Urban"', modify
label define s1q15 8041101 `"Tukusanda"', modify
label define s1q15 8041102 `"Aipanda"', modify
label define s1q15 8041103 `"Tambitanis"', modify
label define s1q15 8041104 `"Lakolam"', modify
label define s1q15 8041105 `"Kubalis"', modify
label define s1q15 8041106 `"Nandi"', modify
label define s1q15 8041107 `"Sakarip"', modify
label define s1q15 8041108 `"Sopas"', modify
label define s1q15 8041109 `"Kiwi"', modify
label define s1q15 8041110 `"Kaiap"', modify
label define s1q15 8041111 `"Kamas"', modify
label define s1q15 8041112 `"Kopen"', modify
label define s1q15 8041113 `"Sari"', modify
label define s1q15 8041114 `"Tore"', modify
label define s1q15 8041115 `"Teremanda"', modify
label define s1q15 8041116 `"Aipinamanda"', modify
label define s1q15 8041117 `"Lakemanda"', modify
label define s1q15 8041118 `"Sakales"', modify
label define s1q15 8041119 `"Keas"', modify
label define s1q15 8041120 `"Irelya"', modify
label define s1q15 8041121 `"Wakumare"', modify
label define s1q15 8041122 `"Lenki"', modify
label define s1q15 8041123 `"Ainumanda"', modify
label define s1q15 8041124 `"Rakamanda"', modify
label define s1q15 8041125 `"Yokomanda"', modify
label define s1q15 8041126 `"Imi"', modify
label define s1q15 8041127 `"We'e"', modify
label define s1q15 8041128 `"Birip"', modify
label define s1q15 8041129 `"Akom"', modify
label define s1q15 8041130 `"Lukirap"', modify
label define s1q15 8041131 `"Waimerimanda"', modify
label define s1q15 8041132 `"Lakopen"', modify
label define s1q15 8041133 `"Yailingis"', modify
label define s1q15 8041201 `"Biak"', modify
label define s1q15 8041202 `"Net Nai"', modify
label define s1q15 8041203 `"Pasalaugus"', modify
label define s1q15 8041204 `"Wailep"', modify
label define s1q15 8041205 `"Tongori"', modify
label define s1q15 8041206 `"Kaematok"', modify
label define s1q15 8041207 `"Wangalongen"', modify
label define s1q15 8041208 `"Neliyakou"', modify
label define s1q15 8041209 `"Ilya"', modify
label define s1q15 8041210 `"Poreak"', modify
label define s1q15 8041211 `"Warakom"', modify
label define s1q15 8041212 `"Pokale"', modify
label define s1q15 8041213 `"Penale"', modify
label define s1q15 8051301 `"Awas"', modify
label define s1q15 8051302 `"Tubiakores"', modify
label define s1q15 8051303 `"Aipanda"', modify
label define s1q15 8051304 `"Kaiamanda"', modify
label define s1q15 8051305 `"Tubels"', modify
label define s1q15 8051306 `"Yalis"', modify
label define s1q15 8051307 `"Yuk"', modify
label define s1q15 8051308 `"Alumbalam"', modify
label define s1q15 8051309 `"Elyaganda"', modify
label define s1q15 8051310 `"Takaipos"', modify
label define s1q15 8051311 `"Mambisanda"', modify
label define s1q15 8051312 `"Kumbas Kau"', modify
label define s1q15 8051313 `"Wares"', modify
label define s1q15 8051315 `"Rauanda"', modify
label define s1q15 8051316 `"Pina"', modify
label define s1q15 8051317 `"Yaibos"', modify
label define s1q15 8051318 `"Topakapos"', modify
label define s1q15 8051319 `"Paus"', modify
label define s1q15 8051320 `"Kuimamanda"', modify
label define s1q15 8051321 `"Kangarapos"', modify
label define s1q15 8051322 `"Pompabus"', modify
label define s1q15 8051323 `"Kanamanda"', modify
label define s1q15 8051324 `"Mondop"', modify
label define s1q15 8051325 `"Pausa"', modify
label define s1q15 8051326 `"Kumbu"', modify
label define s1q15 8051327 `"Yaramanda"', modify
label define s1q15 8051328 `"Tapend"', modify
label define s1q15 8051329 `"Yakaendis"', modify
label define s1q15 8051330 `"Unda"', modify
label define s1q15 8051331 `"Anji"', modify
label define s1q15 8051332 `"Nanai"', modify
label define s1q15 8051333 `"Walya"', modify
label define s1q15 8051334 `"Ipia"', modify
label define s1q15 8051382 `"Wapenamanda Urban"', modify
label define s1q15 8051401 `"Pipites"', modify
label define s1q15 8051402 `"Sapos"', modify
label define s1q15 8051403 `"Komanda"', modify
label define s1q15 8051404 `"Yogos"', modify
label define s1q15 8051405 `"Tangaimanda"', modify
label define s1q15 8051406 `"Kiangapu"', modify
label define s1q15 8051407 `"Pumakos"', modify
label define s1q15 8051408 `"Raiakam"', modify
label define s1q15 8051409 `"Alumanda"', modify
label define s1q15 8051410 `"Poketamanda"', modify
label define s1q15 8051411 `"Ipali"', modify
label define s1q15 8051412 `"Imangapos"', modify
label define s1q15 8051413 `"Sapundis"', modify
label define s1q15 8051414 `"Pitipais"', modify
label define s1q15 8051415 `"Wanimas"', modify
label define s1q15 8051416 `"Londol"', modify
label define s1q15 8051417 `"Kwia"', modify
label define s1q15 9020301 `"Muglamp.1"', modify
label define s1q15 9020302 `"Muglamp.2"', modify
label define s1q15 9020303 `"Mun"', modify
label define s1q15 9020304 `"Gumanch.1"', modify
label define s1q15 9020305 `"Gumanch.2"', modify
label define s1q15 9020306 `"Kuk 1"', modify
label define s1q15 9020307 `"Mopi"', modify
label define s1q15 9020308 `"Keta"', modify
label define s1q15 9020309 `"Keraldong"', modify
label define s1q15 9020310 `"Kumbunga"', modify
label define s1q15 9020311 `"Moga"', modify
label define s1q15 9020312 `"Pung"', modify
label define s1q15 9020313 `"Rauna"', modify
label define s1q15 9020314 `"Kamund"', modify
label define s1q15 9020315 `"Kenembomuka"', modify
label define s1q15 9020318 `"Kenabuga.1"', modify
label define s1q15 9020319 `"Bitam"', modify
label define s1q15 9020329 `"Kindal"', modify
label define s1q15 9020330 `"Palgi"', modify
label define s1q15 9020331 `"Komapana"', modify
label define s1q15 9020336 `"Kelem.1"', modify
label define s1q15 9020339 `"Tigi.2"', modify
label define s1q15 9020340 `"Kenabuga.2"', modify
label define s1q15 9020342 `"Klenembo"', modify
label define s1q15 9020347 `"Tigi.1"', modify
label define s1q15 9021416 `"Kints"', modify
label define s1q15 9021417 `"Mala 1"', modify
label define s1q15 9021420 `"Timbi"', modify
label define s1q15 9021421 `"Dypaiorang"', modify
label define s1q15 9021422 `"Ambuga"', modify
label define s1q15 9021423 `"Kutunga"', modify
label define s1q15 9021424 `"Ruti"', modify
label define s1q15 9021425 `"Kora"', modify
label define s1q15 9021426 `"Penda"', modify
label define s1q15 9021427 `"Kondopina 1"', modify
label define s1q15 9021428 `"Kondopina 2"', modify
label define s1q15 9021432 `"Kinjipi"', modify
label define s1q15 9021433 `"Kinjipi 2"', modify
label define s1q15 9021434 `"Nunga 1"', modify
label define s1q15 9021435 `"Nunga 2"', modify
label define s1q15 9021437 `"Keremunga"', modify
label define s1q15 9021438 `"Romonga"', modify
label define s1q15 9021441 `"Keya"', modify
label define s1q15 9021443 `"Bengel"', modify
label define s1q15 9021444 `"Kembuki"', modify
label define s1q15 9021445 `"Kurunga"', modify
label define s1q15 9021446 `"Rang"', modify
label define s1q15 9021448 `"Rulna"', modify
label define s1q15 9021449 `"Minjim"', modify
label define s1q15 9021450 `"Kentkina"', modify
label define s1q15 9021451 `"Rombanga"', modify
label define s1q15 9030401 `"Kumunga"', modify
label define s1q15 9030402 `"Kiliga"', modify
label define s1q15 9030403 `"Kelua 2"', modify
label define s1q15 9030404 `"Kuguma"', modify
label define s1q15 9030405 `"Kelua 1"', modify
label define s1q15 9030406 `"Kik"', modify
label define s1q15 9030407 `"Tega"', modify
label define s1q15 9030408 `"Koglamp"', modify
label define s1q15 9030409 `"Tiling"', modify
label define s1q15 9030410 `"Kingalrui 1"', modify
label define s1q15 9030411 `"Korobuk"', modify
label define s1q15 9030412 `"Biaprui"', modify
label define s1q15 9030413 `"Keltiga"', modify
label define s1q15 9030414 `"Gabina"', modify
label define s1q15 9030415 `"Palim 2"', modify
label define s1q15 9030416 `"Palim 1"', modify
label define s1q15 9030417 `"Koge 1"', modify
label define s1q15 9030418 `"Koge 2"', modify
label define s1q15 9030419 `"Minimp"', modify
label define s1q15 9030420 `"Ogelbeng"', modify
label define s1q15 9030421 `"Anga"', modify
label define s1q15 9030422 `"Pulgimp"', modify
label define s1q15 9030423 `"Mulga"', modify
label define s1q15 9030424 `"Kitiga"', modify
label define s1q15 9030425 `"Pungaminga"', modify
label define s1q15 9030426 `"Kogmul"', modify
label define s1q15 9030427 `"Pits"', modify
label define s1q15 9030428 `"Togoba No.1"', modify
label define s1q15 9030429 `"Kagamuga"', modify
label define s1q15 9030430 `"Kingaldui 2"', modify
label define s1q15 9030431 `"Baisu"', modify
label define s1q15 9030432 `"Wimbuka"', modify
label define s1q15 9030433 `"Kilam"', modify
label define s1q15 9030434 `"Kenta"', modify
label define s1q15 9030435 `"Koibuga"', modify
label define s1q15 9030436 `"Kagamuga Rural"', modify
label define s1q15 9030437 `"Kugl"', modify
label define s1q15 9030438 `"Waninga"', modify
label define s1q15 9030439 `"Kuguramp"', modify
label define s1q15 9030440 `"Togoba 2"', modify
label define s1q15 9030581 `"Kagamuga Urban"', modify
label define s1q15 9030583 `"Mt.Hagen Town"', modify
label define s1q15 9050801 `"Bukapena"', modify
label define s1q15 9050802 `"Kileg .1"', modify
label define s1q15 9050803 `"Kileg.2"', modify
label define s1q15 9050804 `"Kileg.3"', modify
label define s1q15 9050805 `"Kalenga 1"', modify
label define s1q15 9050806 `"Kalenga 2"', modify
label define s1q15 9050807 `"Wurup"', modify
label define s1q15 9050808 `"Kwinga.1"', modify
label define s1q15 9050809 `"Kwinga.2"', modify
label define s1q15 9050810 `"Kwinga.3"', modify
label define s1q15 9050811 `"Kwinga.4"', modify
label define s1q15 9050812 `"Bita"', modify
label define s1q15 9050813 `"Kum"', modify
label define s1q15 9050814 `"Mabulga.1"', modify
label define s1q15 9050815 `"Mabulga.2"', modify
label define s1q15 9050816 `"Mabulga.3"', modify
label define s1q15 9050817 `"Mambuga.4"', modify
label define s1q15 9050818 `"Rugli.1"', modify
label define s1q15 9050819 `"Rugli.2"', modify
label define s1q15 9050820 `"Keregamp"', modify
label define s1q15 9050821 `"Kopalge"', modify
label define s1q15 9050822 `"Kumdi"', modify
label define s1q15 9050823 `"Namba"', modify
label define s1q15 9050824 `"Murip"', modify
label define s1q15 9050825 `"Kiliga"', modify
label define s1q15 9050826 `"Minimp"', modify
label define s1q15 9050827 `"Koibuga.1"', modify
label define s1q15 9050828 `"Koibuga.2"', modify
label define s1q15 9050829 `"Koibuga.3"', modify
label define s1q15 9050830 `"Koibuga.4"', modify
label define s1q15 9050831 `"Angiki.1"', modify
label define s1q15 9050832 `"Angiki.2"', modify
label define s1q15 9050833 `"Kilimp"', modify
label define s1q15 9050834 `"Wara.1"', modify
label define s1q15 9050835 `"Wara.2"', modify
label define s1q15 9050836 `"Wara.3"', modify
label define s1q15 9050837 `"Kogl"', modify
label define s1q15 9050838 `"Kwip.1"', modify
label define s1q15 9050839 `"Kwip.2"', modify
label define s1q15 9050840 `"Tondomong.1"', modify
label define s1q15 9050841 `"Tondomong.2"', modify
label define s1q15 9050842 `"Tondomong.3"', modify
label define s1q15 9050843 `"Balk.1"', modify
label define s1q15 9050844 `"Balk.2"', modify
label define s1q15 9050845 `"Balk.3"', modify
label define s1q15 9050846 `"Balk.4"', modify
label define s1q15 9050847 `"Ebuga"', modify
label define s1q15 9050901 `"Pokotapugl"', modify
label define s1q15 9050902 `"Manjip"', modify
label define s1q15 9050903 `"Sanap"', modify
label define s1q15 9050904 `"Keluape.1"', modify
label define s1q15 9050905 `"Keluape.2"', modify
label define s1q15 9050906 `"Lyaporambo.2"', modify
label define s1q15 9050907 `"Lyaporambo.1"', modify
label define s1q15 9050908 `"Kaleta"', modify
label define s1q15 9050909 `"Kuipbaut.1"', modify
label define s1q15 9050910 `"Kuipbaut.2"', modify
label define s1q15 9050911 `"Rolga"', modify
label define s1q15 9050912 `"Endeman"', modify
label define s1q15 9050913 `"Jukuna"', modify
label define s1q15 9050914 `"Tapikama.1"', modify
label define s1q15 9050915 `"Tapikama.2"', modify
label define s1q15 9050916 `"Kaliponga"', modify
label define s1q15 9050917 `"Yaramanda.1"', modify
label define s1q15 9050918 `"Yaramanda.2"', modify
label define s1q15 9050919 `"Yaramanda.3"', modify
label define s1q15 9050920 `"Pakalts.1"', modify
label define s1q15 9050921 `"Pakalts.2"', modify
label define s1q15 9050922 `"Dalapana.1"', modify
label define s1q15 9050923 `"Dalapana.2"', modify
label define s1q15 9050924 `"Dalapana.3"', modify
label define s1q15 9050925 `"Kulimbu.1"', modify
label define s1q15 9050926 `"Kulimbu.2"', modify
label define s1q15 9050927 `"Mandawasa.1"', modify
label define s1q15 9050929 `"Kalepale"', modify
label define s1q15 9050930 `"Simunga"', modify
label define s1q15 9050931 `"Kanan.1"', modify
label define s1q15 9050932 `"Kanan.2"', modify
label define s1q15 9050933 `"Yakasmanda.1"', modify
label define s1q15 9050934 `"Yakasmanda.2"', modify
label define s1q15 9050935 `"Iki 1"', modify
label define s1q15 9050936 `"Iki 2"', modify
label define s1q15 9050937 `"Dekenapona"', modify
label define s1q15 9050938 `"Antengena. 1"', modify
label define s1q15 9050939 `"Keld"', modify
label define s1q15 9050940 `"Gelg.1"', modify
label define s1q15 9050941 `"Gelg.2"', modify
label define s1q15 9050942 `"Kul"', modify
label define s1q15 9050943 `"Pila"', modify
label define s1q15 9050944 `"Opa"', modify
label define s1q15 9050945 `"Ruti"', modify
label define s1q15 9050946 `"Tinsley Health Centre"', modify
label define s1q15 9050947 `"Baiyer Station"', modify
label define s1q15 9051001 `"Lai.1"', modify
label define s1q15 9051002 `"Rombau"', modify
label define s1q15 9051003 `"Mondaiyanda"', modify
label define s1q15 9051004 `"Laiyakama.2"', modify
label define s1q15 9051005 `"Nekerapa.1"', modify
label define s1q15 9051007 `"Negerapa.3"', modify
label define s1q15 9051008 `"Pinyapaisa.1"', modify
label define s1q15 9051009 `"Pinapaisa.2"', modify
label define s1q15 9051010 `"Mano"', modify
label define s1q15 9051011 `"Minigiwa"', modify
label define s1q15 9051012 `"Wangumali"', modify
label define s1q15 9051013 `"Kumbakosa.1"', modify
label define s1q15 9051014 `"Kumbakosa.2"', modify
label define s1q15 9051015 `"Yangomanda"', modify
label define s1q15 9051016 `"Sinjumanda"', modify
label define s1q15 9051017 `"Jikama"', modify
label define s1q15 9051018 `"Kunjilama"', modify
label define s1q15 9051019 `"Kakemali.1"', modify
label define s1q15 9051020 `"Kakemali.2"', modify
label define s1q15 9051021 `"Kakemali.3"', modify
label define s1q15 9051022 `"Keimanda"', modify
label define s1q15 9071201 `"Gihamu 1"', modify
label define s1q15 9071202 `"Gihamu 2"', modify
label define s1q15 9071203 `"Muga"', modify
label define s1q15 9071204 `"Paiakona.1"', modify
label define s1q15 9071205 `"Paiakona.2"', modify
label define s1q15 9071206 `"Toroika"', modify
label define s1q15 9071207 `"Kamunga 1"', modify
label define s1q15 9071208 `"Kamunga 2"', modify
label define s1q15 9071209 `"Tomba"', modify
label define s1q15 9071210 `"Tsingibai.1"', modify
label define s1q15 9071211 `"Tsingibai.3"', modify
label define s1q15 9071212 `"Tsingibai  2"', modify
label define s1q15 9071213 `"Tsingibai 4"', modify
label define s1q15 9071214 `"Karapangi"', modify
label define s1q15 9071215 `"Pulgumong"', modify
label define s1q15 9071216 `"Kikuwa"', modify
label define s1q15 9071217 `"Pommboli"', modify
label define s1q15 9071218 `"Kumbaipulg"', modify
label define s1q15 9071219 `"Maltaka"', modify
label define s1q15 9071220 `"Kamindi"', modify
label define s1q15 9071221 `"Pagapena 1"', modify
label define s1q15 9071222 `"Pagapena.2"', modify
label define s1q15 9071223 `"Pagapena 3"', modify
label define s1q15 9071224 `"Oiapulg. 1"', modify
label define s1q15 9071225 `"Oiapugl.2"', modify
label define s1q15 9071226 `"Awabo"', modify
label define s1q15 9071227 `"Laiagam  1"', modify
label define s1q15 9071228 `"Laiagam 2"', modify
label define s1q15 9071229 `"Malke  1"', modify
label define s1q15 9071230 `"Malke 2"', modify
label define s1q15 9071231 `"Kagop 1"', modify
label define s1q15 9071232 `"Kagop 2"', modify
label define s1q15 9071233 `"Kagop 3"', modify
label define s1q15 9071234 `"Alkena 1"', modify
label define s1q15 9071235 `"Alkena 2"', modify
label define s1q15 9071236 `"Alkena.3"', modify
label define s1q15 9071237 `"Iapauga"', modify
label define s1q15 9071238 `"Wambul 1"', modify
label define s1q15 9071239 `"Wambul 2"', modify
label define s1q15 9071240 `"Kopine"', modify
label define s1q15 9071241 `"Bonga.1"', modify
label define s1q15 9071242 `"Bonga.2"', modify
label define s1q15 9071243 `"Koroka"', modify
label define s1q15 9071244 `"Kerepia.1"', modify
label define s1q15 9071245 `"Kerepia.2"', modify
label define s1q15 9071246 `"Kerepia.3"', modify
label define s1q15 9071247 `"Tama"', modify
label define s1q15 9071248 `"Pulpol"', modify
label define s1q15 9071249 `"Gia.1"', modify
label define s1q15 9071250 `"Gia.2"', modify
label define s1q15 9071251 `"Kombolga"', modify
label define s1q15 9071252 `"Marapugl"', modify
label define s1q15 9071301 `"Pabarabuk"', modify
label define s1q15 9071302 `"Papikola"', modify
label define s1q15 9071303 `"Oamul"', modify
label define s1q15 9071304 `"Kupeng"', modify
label define s1q15 9071305 `"Kogmul"', modify
label define s1q15 9071306 `"Malda"', modify
label define s1q15 9071307 `"Teka 1"', modify
label define s1q15 9071308 `"Teka 2"', modify
label define s1q15 9071309 `"Kumbaia"', modify
label define s1q15 9071310 `"Koibuka"', modify
label define s1q15 9071311 `"Yumbiga 1"', modify
label define s1q15 9071312 `"Yumbiga 2"', modify
label define s1q15 9071313 `"Kaige 1"', modify
label define s1q15 9071314 `"Kaige 2"', modify
label define s1q15 9071315 `"Iriwaipa"', modify
label define s1q15 9071316 `"Gomi"', modify
label define s1q15 9071317 `"Tapia"', modify
label define s1q15 9071318 `"Korkor"', modify
label define s1q15 9071319 `"Paraka"', modify
label define s1q15 9071320 `"Alimp 1"', modify
label define s1q15 9071321 `"Alimp 2"', modify
label define s1q15 9071322 `"Kumumbaga"', modify
label define s1q15 9071323 `"Wagil"', modify
label define s1q15 9071324 `"Agega"', modify
label define s1q15 9071325 `"Olk"', modify
label define s1q15 9071326 `"Koibuga"', modify
label define s1q15 9071327 `"Pangatibuk"', modify
label define s1q15 9071328 `"Dumakona"', modify
label define s1q15 9071329 `"Kongra"', modify
label define s1q15 9071330 `"Kend"', modify
label define s1q15 9071331 `"Arowa"', modify
label define s1q15 9071332 `"Wairipi"', modify
label define s1q15 9071333 `"Keranum"', modify
label define s1q15 9071334 `"Kongmul"', modify
label define s1q15 10010101 `"Sirikoge"', modify
label define s1q15 10010102 `"Emegi"', modify
label define s1q15 10010103 `"Membimangi"', modify
label define s1q15 10010104 `"Togoma"', modify
label define s1q15 10010105 `"Agugu"', modify
label define s1q15 10010106 `"Kautambandi"', modify
label define s1q15 10010107 `"Maimagu"', modify
label define s1q15 10010108 `"Goi"', modify
label define s1q15 10010109 `"Mainamo"', modify
label define s1q15 10010110 `"Keu No. 1"', modify
label define s1q15 10010111 `"Keu No. 2"', modify
label define s1q15 10010112 `"Onoma"', modify
label define s1q15 10010113 `"Eigun"', modify
label define s1q15 10010182 `"Chuave Urban"', modify
label define s1q15 10010201 `"Monono"', modify
label define s1q15 10010202 `"Gogo No.1"', modify
label define s1q15 10010203 `"Gogo No.2"', modify
label define s1q15 10010204 `"Kuraigure"', modify
label define s1q15 10010205 `"Kurere 1"', modify
label define s1q15 10010206 `"Kurere 2"', modify
label define s1q15 10010207 `"Giriu No.1"', modify
label define s1q15 10010208 `"Giriu No.2"', modify
label define s1q15 10010209 `"Wangoi"', modify
label define s1q15 10010210 `"Kororume No.1"', modify
label define s1q15 10010211 `"Kururume"', modify
label define s1q15 10010212 `"Yorori"', modify
label define s1q15 10010213 `"Pimuri No.2"', modify
label define s1q15 10010214 `"Pimuri (Oroma)"', modify
label define s1q15 10010215 `"Karaweri No.1"', modify
label define s1q15 10010216 `"Karaweri No.2"', modify
label define s1q15 10010301 `"Kereku"', modify
label define s1q15 10010302 `"Waisime"', modify
label define s1q15 10010303 `"Moreva No.1"', modify
label define s1q15 10010304 `"Mareva"', modify
label define s1q15 10010305 `"Nime"', modify
label define s1q15 10010306 `"Fokowe"', modify
label define s1q15 10010307 `"Kumo"', modify
label define s1q15 10010308 `"Atino"', modify
label define s1q15 10010309 `"Irafaiufa"', modify
label define s1q15 10010310 `"Komuni No. 1"', modify
label define s1q15 10010311 `"Famundi"', modify
label define s1q15 10010312 `"Seine"', modify
label define s1q15 10010313 `"Rabiufa"', modify
label define s1q15 10010314 `"Rumbuiufa"', modify
label define s1q15 10010315 `"Andomono"', modify
label define s1q15 10010316 `"Feremena"', modify
label define s1q15 10010317 `"Wafo"', modify
label define s1q15 10010318 `"Lofaifo"', modify
label define s1q15 10010319 `"Loanoi"', modify
label define s1q15 10010320 `"Nomanena"', modify
label define s1q15 10010321 `"Kemami"', modify
label define s1q15 10010322 `"Nomane"', modify
label define s1q15 10010323 `"Norifo"', modify
label define s1q15 10010324 `"Komborufa"', modify
label define s1q15 10010325 `"Foinawa"', modify
label define s1q15 10010326 `"Komni No. 2"', modify
label define s1q15 10010327 `"Kifiufa"', modify
label define s1q15 10020401 `"Era 1"', modify
label define s1q15 10020402 `"Era 2"', modify
label define s1q15 10020403 `"Era/Buli"', modify
label define s1q15 10020404 `"Omdara"', modify
label define s1q15 10020405 `"Kua"', modify
label define s1q15 10020406 `"Dia"', modify
label define s1q15 10020407 `"Kopan"', modify
label define s1q15 10020408 `"Yuri"', modify
label define s1q15 10020409 `"Deliku"', modify
label define s1q15 10020410 `"Ainaku"', modify
label define s1q15 10020411 `"Kawaleku"', modify
label define s1q15 10020412 `"Nebiku"', modify
label define s1q15 10020501 `"Tagala"', modify
label define s1q15 10020502 `"Omkolai 1"', modify
label define s1q15 10020503 `"Omkolai 2"', modify
label define s1q15 10020504 `"Yani"', modify
label define s1q15 10020505 `"Milinkane"', modify
label define s1q15 10020506 `"Bomaigaulin"', modify
label define s1q15 10020507 `"Kipaku"', modify
label define s1q15 10020508 `"Aleku"', modify
label define s1q15 10020509 `"Kaleku"', modify
label define s1q15 10020510 `"Koiyaku"', modify
label define s1q15 10020511 `"Nigemarime"', modify
label define s1q15 10020512 `"Gumine Stn"', modify
label define s1q15 10020513 `"Kunarku"', modify
label define s1q15 10020514 `"Milaku"', modify
label define s1q15 10020516 `"Egeku"', modify
label define s1q15 10020517 `"Neraku"', modify
label define s1q15 10020518 `"Sabamingaulin"', modify
label define s1q15 10020519 `"Sanigekain"', modify
label define s1q15 10020520 `"Satobuku"', modify
label define s1q15 10020521 `"Kumaikaine"', modify
label define s1q15 10020601 `"Gorma"', modify
label define s1q15 10020602 `"Kel"', modify
label define s1q15 10020603 `"Korokea"', modify
label define s1q15 10020604 `"Digibe"', modify
label define s1q15 10020605 `"Sipagul"', modify
label define s1q15 10020606 `"Genabona"', modify
label define s1q15 10020607 `"Kariglmaril"', modify
label define s1q15 10020608 `"Gaima"', modify
label define s1q15 10020609 `"Munuma"', modify
label define s1q15 10020610 `"Oldale"', modify
label define s1q15 10020611 `"Oldale 1"', modify
label define s1q15 10020612 `"Oldale 2"', modify
label define s1q15 10030701 `"Yuro. 1"', modify
label define s1q15 10030702 `"Yuro. 2"', modify
label define s1q15 10030703 `"Huwaiyo"', modify
label define s1q15 10030704 `"Wario"', modify
label define s1q15 10030705 `"Karimui Station 1"', modify
label define s1q15 10030706 `"Karimui Station 2"', modify
label define s1q15 10030707 `"Norowai"', modify
label define s1q15 10030708 `"Boisamaru 1"', modify
label define s1q15 10030709 `"Boisamaru 2"', modify
label define s1q15 10030710 `"Yogoromaru"', modify
label define s1q15 10030711 `"Dibe 1"', modify
label define s1q15 10030712 `"Dibe 2"', modify
label define s1q15 10030713 `"Negabo"', modify
label define s1q15 10030714 `"Tua 1"', modify
label define s1q15 10030715 `"Tua 2 (Tilige)"', modify
label define s1q15 10030716 `"Masi"', modify
label define s1q15 10030717 `"Maina 1"', modify
label define s1q15 10030718 `"Maina 2"', modify
label define s1q15 10030719 `"Solari (Noru)"', modify
label define s1q15 10030720 `"Sola"', modify
label define s1q15 10030721 `"Waiamani (Dobu)"', modify
label define s1q15 10030722 `"Dobea"', modify
label define s1q15 10030723 `"Orotabe (Bomai)"', modify
label define s1q15 10030724 `"Unane"', modify
label define s1q15 10030725 `"Suruka (Kapi)"', modify
label define s1q15 10030726 `"Haia"', modify
label define s1q15 10030727 `"Soliabeto"', modify
label define s1q15 10030801 `"Dekamane"', modify
label define s1q15 10030802 `"Awna"', modify
label define s1q15 10030803 `"Gaimo"', modify
label define s1q15 10030804 `"Kolu"', modify
label define s1q15 10030805 `"Oru"', modify
label define s1q15 10030806 `"Monowari"', modify
label define s1q15 10030807 `"Kora"', modify
label define s1q15 10030808 `"Dama"', modify
label define s1q15 10030809 `"Hopum"', modify
label define s1q15 10030810 `"Yuwai"', modify
label define s1q15 10030811 `"Kalem"', modify
label define s1q15 10030812 `"Kukama"', modify
label define s1q15 10030813 `"Apuri"', modify
label define s1q15 10030901 `"Banievera"', modify
label define s1q15 10030902 `"Sua Begen"', modify
label define s1q15 10030903 `"Dirima 2"', modify
label define s1q15 10030904 `"Dayani"', modify
label define s1q15 10030905 `"Goroba"', modify
label define s1q15 10030906 `"Aina"', modify
label define s1q15 10030907 `"Perwi"', modify
label define s1q15 10030908 `"Yopakeni"', modify
label define s1q15 10030909 `"Yopaeri"', modify
label define s1q15 10030910 `"Mogiagi"', modify
label define s1q15 10030911 `"Morinil/Kori"', modify
label define s1q15 10030912 `"Yopakul"', modify
label define s1q15 10030913 `"Waido"', modify
label define s1q15 10030914 `"Tapiekul"', modify
label define s1q15 10030915 `"Kobiebalmil"', modify
label define s1q15 10030916 `"Tapai"', modify
label define s1q15 10030917 `"Yuribol"', modify
label define s1q15 10030918 `"Mirima"', modify
label define s1q15 10030919 `"Bori"', modify
label define s1q15 10030920 `"Mulugra"', modify
label define s1q15 10030921 `"Mankon"', modify
label define s1q15 10030922 `"Kama"', modify
label define s1q15 10030923 `"Gaima"', modify
label define s1q15 10030924 `"Sua"', modify
label define s1q15 10041001 `"Nogar"', modify
label define s1q15 10041002 `"Mukuna"', modify
label define s1q15 10041003 `"Bombir"', modify
label define s1q15 10041004 `"Kendine"', modify
label define s1q15 10041005 `"Kambang"', modify
label define s1q15 10041006 `"Sim"', modify
label define s1q15 10041007 `"Dimbinyaundo"', modify
label define s1q15 10041008 `"Duglgambagl"', modify
label define s1q15 10041009 `"Kunbi"', modify
label define s1q15 10041010 `"Kombuku"', modify
label define s1q15 10041011 `"Siambugla Waugku"', modify
label define s1q15 10041012 `"Saimgugla Wauku"', modify
label define s1q15 10041013 `"Genayogombo"', modify
label define s1q15 10041101 `"Dage Mitna 1"', modify
label define s1q15 10041102 `"Dage Mitna 2"', modify
label define s1q15 10041103 `"Dage Mitna 3"', modify
label define s1q15 10041104 `"Dageyogombo 1"', modify
label define s1q15 10041105 `"Dageyogombo 2"', modify
label define s1q15 10041106 `"Kamaneku"', modify
label define s1q15 10041107 `"Siku"', modify
label define s1q15 10041108 `"Kameneku 2"', modify
label define s1q15 10041109 `"Pagau 1"', modify
label define s1q15 10041110 `"Pagau 2"', modify
label define s1q15 10041111 `"Pagau/Sibaigu"', modify
label define s1q15 10041112 `"Pagau 3"', modify
label define s1q15 10041113 `"Pagau 4"', modify
label define s1q15 10041114 `"Giraiku 1"', modify
label define s1q15 10041115 `"Giraiku 2"', modify
label define s1q15 10041116 `"Bindiku"', modify
label define s1q15 10041118 `"Damba"', modify
label define s1q15 10041119 `"Nimaikane"', modify
label define s1q15 10041120 `"Dageyogombo 3"', modify
label define s1q15 10041121 `"Dageminta 4"', modify
label define s1q15 10041122 `"Kamaneku/Siambula"', modify
label define s1q15 10041201 `"Kumga"', modify
label define s1q15 10041202 `"Kumai Bonmeku"', modify
label define s1q15 10041203 `"Yuri"', modify
label define s1q15 10041204 `"Kuma Deingeku"', modify
label define s1q15 10041205 `"Kuma Kindingapam"', modify
label define s1q15 10041206 `"Endugla Nanginku"', modify
label define s1q15 10041207 `"Endugla Kunaunaku 1"', modify
label define s1q15 10041208 `"Endugla Kunaunaku 2"', modify
label define s1q15 10041209 `"Yopa"', modify
label define s1q15 10041210 `"Bandi 2"', modify
label define s1q15 10041211 `"Bandi No. 1"', modify
label define s1q15 10051380 `"Kundiawa Urban"', modify
label define s1q15 10051401 `"Maglau/Wandigle"', modify
label define s1q15 10051402 `"Maglau/Komkane 1"', modify
label define s1q15 10051403 `"Maglau/Komkane 2"', modify
label define s1q15 10051404 `"Maglau/Deglaku 1"', modify
label define s1q15 10051405 `"Maglau"', modify
label define s1q15 10051406 `"Maglau/Denglaku 2"', modify
label define s1q15 10051407 `"Inaugl 1"', modify
label define s1q15 10051408 `"Inaugl 2"', modify
label define s1q15 10051409 `"Inaugl 3"', modify
label define s1q15 10051410 `"Inaugl/Kunaiku"', modify
label define s1q15 10051411 `"Inaugl 4"', modify
label define s1q15 10051412 `"Kuglkane 1"', modify
label define s1q15 10051413 `"Kuglkane 2"', modify
label define s1q15 10051414 `"Kuglkane 3"', modify
label define s1q15 10051415 `"Kuglkane 4"', modify
label define s1q15 10051416 `"Kuglkane 5"', modify
label define s1q15 10051417 `"Kuglkane 6"', modify
label define s1q15 10051501 `"Kewandeku/Mainagl"', modify
label define s1q15 10051502 `"Girai Tamagle/Anga"', modify
label define s1q15 10051503 `"Girai Tamagle"', modify
label define s1q15 10051504 `"Nunuiomane 1"', modify
label define s1q15 10051505 `"Nunuiomane 2"', modify
label define s1q15 10051506 `"Kewandeku/Dugpag"', modify
label define s1q15 10051507 `"Kengaglku/Kalaku 1"', modify
label define s1q15 10051508 `"Kengaglku/Kalaku 2"', modify
label define s1q15 10051509 `"Kombri 2"', modify
label define s1q15 10051510 `"Gandenkoraglku"', modify
label define s1q15 10051511 `"Koromba Barengigl"', modify
label define s1q15 10051512 `"Kengaglku/Kruglku"', modify
label define s1q15 10051513 `"Girai Tamage"', modify
label define s1q15 10051601 `"Kupau"', modify
label define s1q15 10051602 `"Pari"', modify
label define s1q15 10051603 `"Kurumugl"', modify
label define s1q15 10051604 `"Nogoma"', modify
label define s1q15 10051605 `"Koglai"', modify
label define s1q15 10051606 `"Anigl"', modify
label define s1q15 10051607 `"Guo"', modify
label define s1q15 10051608 `"Wandi"', modify
label define s1q15 10051609 `"Yuagle/Mindima Camp"', modify
label define s1q15 10051610 `"Mindima"', modify
label define s1q15 10051611 `"Gor"', modify
label define s1q15 10051613 `"Koroma"', modify
label define s1q15 10051614 `"Nogar"', modify
label define s1q15 10061701 `"Bulagesible"', modify
label define s1q15 10061702 `"Gilmai/Arebi"', modify
label define s1q15 10061703 `"Maima"', modify
label define s1q15 10061704 `"Temisnowai"', modify
label define s1q15 10061705 `"Galaku"', modify
label define s1q15 10061706 `"Klai"', modify
label define s1q15 10061707 `"Masul 1"', modify
label define s1q15 10061708 `"Masul 2"', modify
label define s1q15 10061709 `"Yalemesi"', modify
label define s1q15 10061710 `"Yalkomno"', modify
label define s1q15 10061711 `"Kapma (Garen)"', modify
label define s1q15 10061712 `"Kapma (Mak)"', modify
label define s1q15 10061713 `"Woma"', modify
label define s1q15 10061714 `"Kautabandi"', modify
label define s1q15 10061801 `"Dugul"', modify
label define s1q15 10061802 `"Oglewaula"', modify
label define s1q15 10061803 `"Bomaiku"', modify
label define s1q15 10061804 `"Du 1"', modify
label define s1q15 10061805 `"Du 2"', modify
label define s1q15 10061806 `"Du 3"', modify
label define s1q15 10061807 `"Kiriyu/Sipa"', modify
label define s1q15 10061808 `"Aniku"', modify
label define s1q15 10061809 `"Kirku/Korul"', modify
label define s1q15 10061810 `"Niniku"', modify
label define s1q15 10061811 `"Piga"', modify
label define s1q15 10061812 `"Kagle"', modify
label define s1q15 10061813 `"Digakane"', modify
label define s1q15 10061814 `"Kumankane"', modify
label define s1q15 10061815 `"Au/Erakane"', modify
label define s1q15 10061816 `"Kagugl"', modify
label define s1q15 10061817 `"Yoruaku"', modify
label define s1q15 10061818 `"Segima"', modify
label define s1q15 10061819 `"Kuiam"', modify
label define s1q15 10061820 `"Maribebi-Kui"', modify
label define s1q15 10061821 `"Kebil 1"', modify
label define s1q15 10061822 `"Kebil2"', modify
label define s1q15 10061823 `"Kaepai"', modify
label define s1q15 10061901 `"Mogl"', modify
label define s1q15 10061902 `"Kagai"', modify
label define s1q15 10061903 `"Guruma 1"', modify
label define s1q15 10061904 `"Guruma 2"', modify
label define s1q15 10061905 `"Muasugo"', modify
label define s1q15 10061907 `"Mai"', modify
label define s1q15 10061908 `"Niglguma 1"', modify
label define s1q15 10061909 `"Niglguma 2"', modify
label define s1q15 10061910 `"Niglguma 3"', modify
label define s1q15 10061911 `"Ku 1"', modify
label define s1q15 10061912 `"Ku 2"', modify
label define s1q15 11010101 `"Mangiro"', modify
label define s1q15 11010102 `"Kenangi"', modify
label define s1q15 11010103 `"Koningi"', modify
label define s1q15 11010104 `"Komoingareka"', modify
label define s1q15 11010105 `"Yamofe"', modify
label define s1q15 11010106 `"Komongu"', modify
label define s1q15 11011201 `"Mando-Yamayufa"', modify
label define s1q15 11011202 `"Korepa"', modify
label define s1q15 11011203 `"Asaro No. 1"', modify
label define s1q15 11011204 `"Asaro No. 2"', modify
label define s1q15 11011205 `"Tafeto/Wantrifu"', modify
label define s1q15 11011206 `"Gamiyuho"', modify
label define s1q15 11011207 `"Lunumbeyuho"', modify
label define s1q15 11011208 `"Kanosa"', modify
label define s1q15 11011209 `"Kofena"', modify
label define s1q15 11011301 `"Anengu"', modify
label define s1q15 11011302 `"Kombiangu/Amaiufa"', modify
label define s1q15 11011303 `"Namta"', modify
label define s1q15 11011304 `"Pikosa"', modify
label define s1q15 11011305 `"Aneguyufa"', modify
label define s1q15 11011306 `"Kwonggi No. 1"', modify
label define s1q15 11011307 `"Kwonggi 2"', modify
label define s1q15 11020201 `"Upper Yaukave"', modify
label define s1q15 11020202 `"Lower Yaukave"', modify
label define s1q15 11020203 `"Kami-Seigu"', modify
label define s1q15 11020204 `"Kama"', modify
label define s1q15 11020205 `"Fimito"', modify
label define s1q15 11020206 `"Kotuni"', modify
label define s1q15 11020207 `"Gahuku"', modify
label define s1q15 11020208 `"Gehamo"', modify
label define s1q15 11020380 `"Goroka Urban"', modify
label define s1q15 11020385 `"Bihute"', modify
label define s1q15 11021401 `"Zomaga"', modify
label define s1q15 11021402 `"Ifiyufa"', modify
label define s1q15 11021403 `"Nokondi"', modify
label define s1q15 11021404 `"Kabiufa No.2"', modify
label define s1q15 11030401 `"Kompri"', modify
label define s1q15 11030402 `"Krevanofi"', modify
label define s1q15 11030403 `"Avani"', modify
label define s1q15 11030404 `"Ababe"', modify
label define s1q15 11030405 `"Yohotegave"', modify
label define s1q15 11030406 `"Fomurenave"', modify
label define s1q15 11030407 `"Finintugu"', modify
label define s1q15 11030408 `"Kamanonka"', modify
label define s1q15 11030409 `"Tebega"', modify
label define s1q15 11030410 `"Tebenofi"', modify
label define s1q15 11030411 `"Henganofi Station"', modify
label define s1q15 11031501 `"Lihona"', modify
label define s1q15 11031502 `"Kuyahapa"', modify
label define s1q15 11031503 `"Kesevaka No 2"', modify
label define s1q15 11031504 `"Kesevaka No 1"', modify
label define s1q15 11031505 `"Haguragave"', modify
label define s1q15 11031506 `"Kiviringka"', modify
label define s1q15 11031507 `"Herave"', modify
label define s1q15 11031508 `"Kemenave"', modify
label define s1q15 11031601 `"Yate"', modify
label define s1q15 11031602 `"Kuru"', modify
label define s1q15 11031603 `"Yameve"', modify
label define s1q15 11031604 `"Kripave"', modify
label define s1q15 11031605 `"Faiyantina"', modify
label define s1q15 11031606 `"Nunofi"', modify
label define s1q15 11031607 `"Fore"', modify
label define s1q15 11031608 `"Kuana"', modify
label define s1q15 11031609 `"Numuyagave"', modify
label define s1q15 11031610 `"Krebave"', modify
label define s1q15 11031611 `"Kofionka"', modify
label define s1q15 11040501 `"Sohe"', modify
label define s1q15 11040502 `"Usurufa"', modify
label define s1q15 11040503 `"Karufa/Tafesa"', modify
label define s1q15 11040504 `"Ijavinon - Ta"', modify
label define s1q15 11040505 `"Anumaga"', modify
label define s1q15 11040506 `"Yamaso"', modify
label define s1q15 11040681 `"Kainantu Urban"', modify
label define s1q15 11040682 `"Aiyura Urban"', modify
label define s1q15 11040683 `"Ukarumpa S.I.L."', modify
label define s1q15 11040684 `"Yonki Township"', modify
label define s1q15 11041701 `"Onampinka"', modify
label define s1q15 11041703 `"Iva"', modify
label define s1q15 11041704 `"Omena"', modify
label define s1q15 11041705 `"Ino'onka"', modify
label define s1q15 11041801 `"Ramu"', modify
label define s1q15 11041802 `"Onkono"', modify
label define s1q15 11041803 `"Aubana"', modify
label define s1q15 11041804 `"Pakino"', modify
label define s1q15 11041805 `"Anonapa"', modify
label define s1q15 11041806 `"Akuitenu"', modify
label define s1q15 11041807 `"Anawa-Yonki"', modify
label define s1q15 11041808 `"Yonki No.1"', modify
label define s1q15 11050701 `"Megino No 2"', modify
label define s1q15 11050702 `"Maimafu"', modify
label define s1q15 11050703 `"Giuasa"', modify
label define s1q15 11050704 `"Mane No 2"', modify
label define s1q15 11050705 `"Maiva"', modify
label define s1q15 11050706 `"Ubaigubi"', modify
label define s1q15 11050707 `"Herowana"', modify
label define s1q15 11050708 `"Agibu"', modify
label define s1q15 11050709 `"Mane No 1"', modify
label define s1q15 11052001 `"Agotu"', modify
label define s1q15 11052002 `"Hegeturu"', modify
label define s1q15 11052003 `"Fiamotave"', modify
label define s1q15 11052004 `"Megino No 1"', modify
label define s1q15 11052005 `"Gouno"', modify
label define s1q15 11052006 `"Beha"', modify
label define s1q15 11052007 `"Korowa"', modify
label define s1q15 11052008 `"Lufa Station"', modify
label define s1q15 11052009 `"Hairo"', modify
label define s1q15 11052010 `"Menilo"', modify
label define s1q15 11052011 `"Hagaulo"', modify
label define s1q15 11052012 `"Kuruku"', modify
label define s1q15 11052101 `"Higivavi"', modify
label define s1q15 11052102 `"Oliguti"', modify
label define s1q15 11052103 `"Kami"', modify
label define s1q15 11052104 `"Forapi No 1"', modify
label define s1q15 11052105 `"Litipinaga"', modify
label define s1q15 11052106 `"Gotomi"', modify
label define s1q15 11052107 `"Lufugu"', modify
label define s1q15 11052108 `"Kiseveroka"', modify
label define s1q15 11052109 `"Kogoraipa"', modify
label define s1q15 11052110 `"Daginava"', modify
label define s1q15 11052111 `"Nupuru"', modify
label define s1q15 11060801 `"Motokara"', modify
label define s1q15 11060802 `"Kobara"', modify
label define s1q15 11060803 `"Atagara"', modify
label define s1q15 11060804 `"Numbaira"', modify
label define s1q15 11060805 `"Bibeori"', modify
label define s1q15 11060806 `"Baira No 2"', modify
label define s1q15 11060807 `"Baira No 1"', modify
label define s1q15 11060808 `"Mei'auna"', modify
label define s1q15 11060809 `"Ogurataba"', modify
label define s1q15 11060810 `"Bi'api'arata"', modify
label define s1q15 11060811 `"Bakumpa"', modify
label define s1q15 11060812 `"Kawaina No 1"', modify
label define s1q15 11060813 `"Kumbora"', modify
label define s1q15 11060814 `"Saurona"', modify
label define s1q15 11060815 `"Obura Gov't Stn"', modify
label define s1q15 11060816 `"Kurunumbura"', modify
label define s1q15 11060817 `"Yunura"', modify
label define s1q15 11060818 `"Asara"', modify
label define s1q15 11060819 `"Himarata"', modify
label define s1q15 11060820 `"Anima"', modify
label define s1q15 11060821 `"Tunana"', modify
label define s1q15 11060822 `"Ahea"', modify
label define s1q15 11060823 `"Habi ina"', modify
label define s1q15 11060824 `"Oraura No 1"', modify
label define s1q15 11060825 `"Kokombira"', modify
label define s1q15 11060826 `"Pinata"', modify
label define s1q15 11060827 `"Owena"', modify
label define s1q15 11060828 `"Tainoraba"', modify
label define s1q15 11060829 `"Mobutasa"', modify
label define s1q15 11060830 `"Agamusi"', modify
label define s1q15 11060901 `"Garipme"', modify
label define s1q15 11060902 `"Marawaka Stn"', modify
label define s1q15 11060903 `"Kwalusila"', modify
label define s1q15 11060904 `"Marawaka"', modify
label define s1q15 11060905 `"Giliwato"', modify
label define s1q15 11060906 `"Gawoi"', modify
label define s1q15 11060907 `"Sindainya"', modify
label define s1q15 11060908 `"Jomuru"', modify
label define s1q15 11060909 `"Yamuru"', modify
label define s1q15 11060910 `"Mala"', modify
label define s1q15 11060911 `"Sinei"', modify
label define s1q15 11060912 `"Asenave"', modify
label define s1q15 11060913 `"Boiko"', modify
label define s1q15 11060914 `"Malari"', modify
label define s1q15 11060915 `"Devevi"', modify
label define s1q15 11060916 `"Yelia"', modify
label define s1q15 11060917 `"Sesai / Tjejai"', modify
label define s1q15 11060918 `"Kandwe / Miniri"', modify
label define s1q15 11060919 `"Dungkwi"', modify
label define s1q15 11060920 `"Ijelelukore"', modify
label define s1q15 11060921 `"Nire"', modify
label define s1q15 11060922 `"Pinji"', modify
label define s1q15 11060923 `"Ororingo"', modify
label define s1q15 11060924 `"Wiobo"', modify
label define s1q15 11060925 `"Yanyi"', modify
label define s1q15 11060926 `"Wapme/Wonenara"', modify
label define s1q15 11060927 `"Butnari"', modify
label define s1q15 11060928 `"Yabwiara"', modify
label define s1q15 11060929 `"Orobina"', modify
label define s1q15 11060930 `"Andakombi"', modify
label define s1q15 11060932 `"Yakana"', modify
label define s1q15 11060933 `"Simogu"', modify
label define s1q15 11071001 `"Purosa"', modify
label define s1q15 11071002 `"Awarosa"', modify
label define s1q15 11071003 `"Orie"', modify
label define s1q15 11071004 `"Unasa"', modify
label define s1q15 11071005 `"Yagareba"', modify
label define s1q15 11071006 `"Paegatasa"', modify
label define s1q15 11071007 `"Oma-Kasoru"', modify
label define s1q15 11071008 `"Yasubi"', modify
label define s1q15 11071009 `"Yagusa"', modify
label define s1q15 11071010 `"Ibusa"', modify
label define s1q15 11071011 `"Kasoru"', modify
label define s1q15 11071012 `"Ofafina"', modify
label define s1q15 11071013 `"Okapa Station"', modify
label define s1q15 11071014 `"Kawaina"', modify
label define s1q15 11071015 `"Amaira"', modify
label define s1q15 11071016 `"Asempa"', modify
label define s1q15 11071017 `"Sefuna"', modify
label define s1q15 11072201 `"Kemiu"', modify
label define s1q15 11072202 `"Kokopi"', modify
label define s1q15 11072203 `"Wayoepa"', modify
label define s1q15 11072204 `"Tarabo"', modify
label define s1q15 11072205 `"Ke'efu"', modify
label define s1q15 11072206 `"Yagana"', modify
label define s1q15 11072207 `"Haga"', modify
label define s1q15 11072208 `"Henagaru"', modify
label define s1q15 11072209 `"Orandatu"', modify
label define s1q15 11072210 `"Amuraisa"', modify
label define s1q15 11072211 `"Hogaveru"', modify
label define s1q15 11072212 `"Aivesu"', modify
label define s1q15 11072213 `"Tarotu-Mane"', modify
label define s1q15 11072214 `"Tunukau"', modify
label define s1q15 11072216 `"Amusa"', modify
label define s1q15 11072217 `"Keteve"', modify
label define s1q15 11081101 `"Siokie"', modify
label define s1q15 11081102 `"Katagu"', modify
label define s1q15 11081103 `"Ketarabo"', modify
label define s1q15 11081104 `"Korofeigu"', modify
label define s1q15 11081105 `"Magitu"', modify
label define s1q15 11081106 `"Hofagaiufa"', modify
label define s1q15 11081107 `"Conner Bena"', modify
label define s1q15 11082301 `"Rintebe"', modify
label define s1q15 11082302 `"Mipo Klopabo / Nayufa - Nipuvo"', modify
label define s1q15 11082303 `"Yatgu-Safa Megunagu"', modify
label define s1q15 11082304 `"Benevenabo / Segerehei"', modify
label define s1q15 11082305 `"Kogaru Megabo"', modify
label define s1q15 11082306 `"Kuritafa/Megabo No.2"', modify
label define s1q15 11082307 `"Liorofa"', modify
label define s1q15 11082401 `"Aligayufa"', modify
label define s1q15 11082402 `"Yabiyufa"', modify
label define s1q15 11082403 `"Wando"', modify
label define s1q15 11082404 `"Orumba"', modify
label define s1q15 11082405 `"Orumba-Foe"', modify
label define s1q15 11082406 `"Yauna-Koko"', modify
label define s1q15 12010110 `"Timini"', modify
label define s1q15 12010111 `"Hengambu"', modify
label define s1q15 12010112 `"Gurakor"', modify
label define s1q15 12010113 `"Patep"', modify
label define s1q15 12010114 `"Parakris"', modify
label define s1q15 12010115 `"Yanta"', modify
label define s1q15 12010116 `"Zenag"', modify
label define s1q15 12010117 `"Kumalu"', modify
label define s1q15 12010118 `"Sambio"', modify
label define s1q15 12010119 `"Latukatop"', modify
label define s1q15 12010120 `"Baiyune"', modify
label define s1q15 12010121 `"Galawo"', modify
label define s1q15 12010122 `"Dambi"', modify
label define s1q15 12010123 `"Mumeng Station"', modify
label define s1q15 12010124 `"Witipos"', modify
label define s1q15 12010125 `"Kapin"', modify
label define s1q15 12010126 `"Tayek"', modify
label define s1q15 12010127 `"Bupu"', modify
label define s1q15 12010128 `"Piu"', modify
label define s1q15 12010129 `"Dangal/"', modify
label define s1q15 12010201 `"Saiwarika"', modify
label define s1q15 12010202 `"Arabuka"', modify
label define s1q15 12010203 `"Gusuwe"', modify
label define s1q15 12010204 `"Pagau"', modify
label define s1q15 12010205 `"Kasuma"', modify
label define s1q15 12010206 `"Gataipa"', modify
label define s1q15 12010207 `"Sim"', modify
label define s1q15 12010208 `"Wisi"', modify
label define s1q15 12010209 `"Kasangare"', modify
label define s1q15 12010210 `"Timanigosa"', modify
label define s1q15 12010211 `"Garaina Station"', modify
label define s1q15 12010212 `"Garaina"', modify
label define s1q15 12010213 `"Tiaura"', modify
label define s1q15 12010214 `"Peira"', modify
label define s1q15 12010215 `"Garasa"', modify
label define s1q15 12010216 `"Ohe"', modify
label define s1q15 12010217 `"Biawaria"', modify
label define s1q15 12010301 `"Menhi"', modify
label define s1q15 12010302 `"Hawata"', modify
label define s1q15 12010303 `"Pararoa"', modify
label define s1q15 12010304 `"Andarora"', modify
label define s1q15 12010305 `"Society"', modify
label define s1q15 12010306 `"Sapanda"', modify
label define s1q15 12010307 `"Gawapu"', modify
label define s1q15 12010308 `"Nauti Aid Post"', modify
label define s1q15 12010309 `"Ekopa"', modify
label define s1q15 12010310 `"Baini"', modify
label define s1q15 12010311 `"Kebi"', modify
label define s1q15 12010312 `"Malangta"', modify
label define s1q15 12010480 `"Bulolo Urban"', modify
label define s1q15 12010481 `"Wau Urban"', modify
label define s1q15 12010501 `"Maus Bokis"', modify
label define s1q15 12010502 `"Mrs Booth"', modify
label define s1q15 12010503 `"Maus Kuranga"', modify
label define s1q15 12010504 `"4 Mile/Nami"', modify
label define s1q15 12010505 `"Wara Muli (DAL Stn.)"', modify
label define s1q15 12010506 `"Nemnem Station"', modify
label define s1q15 12010507 `"Eddie Creek"', modify
label define s1q15 12010508 `"Bitoi"', modify
label define s1q15 12010509 `"Wandumi"', modify
label define s1q15 12010510 `"Sandy Creek"', modify
label define s1q15 12010511 `"Kwembu"', modify
label define s1q15 12010512 `"Kaisenik"', modify
label define s1q15 12010513 `"Biawen"', modify
label define s1q15 12010514 `"Were Were"', modify
label define s1q15 12010515 `"Winima"', modify
label define s1q15 12010516 `"Elauru"', modify
label define s1q15 12010517 `"Wisini"', modify
label define s1q15 12010518 `"Kembaka"', modify
label define s1q15 12010519 `"Tori"', modify
label define s1q15 12010520 `"Tekadu"', modify
label define s1q15 12012901 `"Bugiau"', modify
label define s1q15 12012902 `"Wagau"', modify
label define s1q15 12012903 `"Mambumb"', modify
label define s1q15 12012905 `"Aiyayok"', modify
label define s1q15 12012906 `"Rari/Bugweb"', modify
label define s1q15 12012907 `"Dawong"', modify
label define s1q15 12012908 `"Lomalom"', modify
label define s1q15 12012909 `"Bulandem"', modify
label define s1q15 12012910 `"Chimburuk"', modify
label define s1q15 12012911 `"Mapos 1"', modify
label define s1q15 12012912 `"Mapos 2"', modify
label define s1q15 12012913 `"Sagaiyo"', modify
label define s1q15 12012914 `"Pepekane"', modify
label define s1q15 12012915 `"Lagis/Tokane"', modify
label define s1q15 12012916 `"Mannga"', modify
label define s1q15 12012917 `"Bayamatu"', modify
label define s1q15 12012918 `"Kwasang"', modify
label define s1q15 12012919 `"Zeri"', modify
label define s1q15 12012920 `"Zamondang/Bayauaga"', modify
label define s1q15 12020618 `"Tireng"', modify
label define s1q15 12020619 `"Unsesu"', modify
label define s1q15 12020620 `"Gemaheng"', modify
label define s1q15 12020621 `"Sembang (Sofifi)"', modify
label define s1q15 12020622 `"Sanangac"', modify
label define s1q15 12020623 `"Zaningu"', modify
label define s1q15 12020624 `"Homoneng"', modify
label define s1q15 12020625 `"Morago"', modify
label define s1q15 12020626 `"Besibong"', modify
label define s1q15 12020627 `"Pindiu Station"', modify
label define s1q15 12020628 `"Zenguru"', modify
label define s1q15 12020629 `"Qwakugu"', modify
label define s1q15 12020630 `"Genna"', modify
label define s1q15 12020631 `"Gaeng"', modify
label define s1q15 12020701 `"Keregia"', modify
label define s1q15 12020702 `"Merikeo"', modify
label define s1q15 12020703 `"Bolingboneng"', modify
label define s1q15 12020704 `"Yunzaing"', modify
label define s1q15 12020705 `"Wareo"', modify
label define s1q15 12020706 `"Fior"', modify
label define s1q15 12020707 `"Maruruo"', modify
label define s1q15 12020708 `"Jivewaneng"', modify
label define s1q15 12020709 `"Siki"', modify
label define s1q15 12020710 `"Heldback"', modify
label define s1q15 12020801 `"Kamlawa"', modify
label define s1q15 12020802 `"Simbang"', modify
label define s1q15 12020803 `"Bugaim"', modify
label define s1q15 12020804 `"Nasingalatu"', modify
label define s1q15 12020805 `"Sokaneng"', modify
label define s1q15 12020806 `"Kwalansam"', modify
label define s1q15 12020807 `"Kasanga"', modify
label define s1q15 12020808 `"Busiga"', modify
label define s1q15 12020809 `"Wanam/ Tami Island"', modify
label define s1q15 12020810 `"Bukawasip"', modify
label define s1q15 12020811 `"Tigidu"', modify
label define s1q15 12020813 `"Samantiki"', modify
label define s1q15 12020814 `"Mawaneng"', modify
label define s1q15 12020815 `"Embewaneng"', modify
label define s1q15 12020816 `"Mangao"', modify
label define s1q15 12020817 `"Kangaruo"', modify
label define s1q15 12020818 `"Haponhongdong"', modify
label define s1q15 12020819 `"Buang"', modify
label define s1q15 12020820 `"Gurungko"', modify
label define s1q15 12020821 `"Yombong"', modify
label define s1q15 12023201 `"Kotken"', modify
label define s1q15 12023202 `"Zengaring"', modify
label define s1q15 12023203 `"Numbut"', modify
label define s1q15 12023204 `"Ubanong"', modify
label define s1q15 12023205 `"Koire"', modify
label define s1q15 12023206 `"Songolok"', modify
label define s1q15 12023207 `"Nomaneneng"', modify
label define s1q15 12023208 `"Sagiro"', modify
label define s1q15 12023209 `"Ogeranang"', modify
label define s1q15 12023210 `"Serembeng"', modify
label define s1q15 12023211 `"Origenang"', modify
label define s1q15 12023212 `"Manimbu"', modify
label define s1q15 12023213 `"Wamoki"', modify
label define s1q15 12023214 `"Ebabang"', modify
label define s1q15 12023215 `"Hamoronong"', modify
label define s1q15 12023216 `"Sangararang"', modify
label define s1q15 12023217 `"Tumnong"', modify
label define s1q15 12023218 `"Mindik"', modify
label define s1q15 12023219 `"Satneng"', modify
label define s1q15 12023220 `"Wagang"', modify
label define s1q15 12023221 `"Tobou"', modify
label define s1q15 12023222 `"Lengbatti"', modify
label define s1q15 12023223 `"Awengu"', modify
label define s1q15 12023224 `"Sasiu"', modify
label define s1q15 12030901 `"Kui"', modify
label define s1q15 12030902 `"Paiawa"', modify
label define s1q15 12030903 `"Miama"', modify
label define s1q15 12030904 `"Zinamba"', modify
label define s1q15 12030905 `"Zigori"', modify
label define s1q15 12030906 `"Amoa"', modify
label define s1q15 12030907 `"Bosadi"', modify
label define s1q15 12030908 `"Mou"', modify
label define s1q15 12030909 `"Ana"', modify
label define s1q15 12030910 `"Eware"', modify
label define s1q15 12030911 `"Kobo"', modify
label define s1q15 12030912 `"Eiya"', modify
label define s1q15 12030913 `"Wuwu"', modify
label define s1q15 12030914 `"Dona"', modify
label define s1q15 12030915 `"Ainse"', modify
label define s1q15 12030916 `"Zare"', modify
label define s1q15 12030917 `"Siu"', modify
label define s1q15 12030918 `"Popoe"', modify
label define s1q15 12030919 `"Bau"', modify
label define s1q15 12030920 `"Morobe Station"', modify
label define s1q15 12030921 `"Pema"', modify
label define s1q15 12031001 `"Hote"', modify
label define s1q15 12031002 `"Yemly"', modify
label define s1q15 12031003 `"Bobodum"', modify
label define s1q15 12031004 `"Selebob"', modify
label define s1q15 12031005 `"Kamiatum"', modify
label define s1q15 12031006 `"Mubo"', modify
label define s1q15 12031007 `"Lababia"', modify
label define s1q15 12031008 `"Salus"', modify
label define s1q15 12031009 `"Buansing"', modify
label define s1q15 12031010 `"Laukanu"', modify
label define s1q15 12031011 `"Laugui"', modify
label define s1q15 12031012 `"Keila"', modify
label define s1q15 12031013 `"Asini"', modify
label define s1q15 12031014 `"Buakap"', modify
label define s1q15 12031015 `"Lutu Busama"', modify
label define s1q15 12031016 `"Awasa Busama"', modify
label define s1q15 12031017 `"Wabubu"', modify
label define s1q15 12031101 `"Mare"', modify
label define s1q15 12031102 `"Wampit"', modify
label define s1q15 12031103 `"Gabensis"', modify
label define s1q15 12031104 `"Omisi"', modify
label define s1q15 12031105 `"Markham Bridge"', modify
label define s1q15 12031106 `"Labutale"', modify
label define s1q15 12031107 `"Labumiti"', modify
label define s1q15 12031108 `"Labubutu"', modify
label define s1q15 12031109 `"5 Mile"', modify
label define s1q15 12031110 `"St Joseph"', modify
label define s1q15 12031111 `"Awillunga"', modify
label define s1q15 12031112 `"Bubia"', modify
label define s1q15 12031113 `"Busanim"', modify
label define s1q15 12031114 `"Yalu"', modify
label define s1q15 12031115 `"Munum"', modify
label define s1q15 12031116 `"Nasuapum"', modify
label define s1q15 12031117 `"Gapsongkeg"', modify
label define s1q15 12031118 `"Naromangki"', modify
label define s1q15 12031119 `"Chivasing"', modify
label define s1q15 12031120 `"Tararan"', modify
label define s1q15 12031121 `"Noa"', modify
label define s1q15 12031122 `"Bogeba"', modify
label define s1q15 12031123 `"Irumu"', modify
label define s1q15 12031124 `"Uruf"', modify
label define s1q15 12031125 `"Tsilitsili"', modify
label define s1q15 12031126 `"Maralina"', modify
label define s1q15 12031127 `"Maralangko"', modify
label define s1q15 12041201 `"Hamelengan"', modify
label define s1q15 12041202 `"Komutu"', modify
label define s1q15 12041203 `"Yalument Station"', modify
label define s1q15 12041204 `"Etaino"', modify
label define s1q15 12041205 `"Birimon"', modify
label define s1q15 12041206 `"Gomandat"', modify
label define s1q15 12041207 `"Lewemon"', modify
label define s1q15 12041208 `"Takop"', modify
label define s1q15 12041209 `"Timovon"', modify
label define s1q15 12041210 `"Mumunggam"', modify
label define s1q15 12041211 `"Sambangan"', modify
label define s1q15 12041212 `"Ongakei"', modify
label define s1q15 12041213 `"Yakop"', modify
label define s1q15 12041214 `"Yandu"', modify
label define s1q15 12041215 `"Derim"', modify
label define s1q15 12041216 `"Songgin"', modify
label define s1q15 12041401 `"Worin"', modify
label define s1q15 12041402 `"Sugan"', modify
label define s1q15 12041403 `"Boksawin"', modify
label define s1q15 12041404 `"Dinangat"', modify
label define s1q15 12041405 `"Gorgiok"', modify
label define s1q15 12041406 `"Bungawat"', modify
label define s1q15 12041407 `"Mek"', modify
label define s1q15 12041408 `"Isan"', modify
label define s1q15 12041409 `"Wadabung"', modify
label define s1q15 12041410 `"Nokopo"', modify
label define s1q15 12041411 `"Gua"', modify
label define s1q15 12041412 `"Keweng"', modify
label define s1q15 12041413 `"Mengang"', modify
label define s1q15 12043101 `"Zangang"', modify
label define s1q15 12043102 `"Taknawe"', modify
label define s1q15 12043103 `"Malandum"', modify
label define s1q15 12043104 `"Mangam"', modify
label define s1q15 12043105 `"Nakambuk"', modify
label define s1q15 12043106 `"Somboru"', modify
label define s1q15 12043107 `"Satwak"', modify
label define s1q15 12043108 `"Langa"', modify
label define s1q15 12043109 `"Saune/Kopa"', modify
label define s1q15 12043110 `"Waran"', modify
label define s1q15 12043111 `"Indagen"', modify
label define s1q15 12043112 `"Musep"', modify
label define s1q15 12043113 `"Geraun"', modify
label define s1q15 12043114 `"Konge"', modify
label define s1q15 12043115 `"Ununu"', modify
label define s1q15 12043116 `"Sikam"', modify
label define s1q15 12043117 `"Kambuk"', modify
label define s1q15 12043118 `"Sape"', modify
label define s1q15 12043119 `"Gumum"', modify
label define s1q15 12043502 `"Nimbako"', modify
label define s1q15 12043503 `"Wap"', modify
label define s1q15 12043504 `"Sorong/Kusin"', modify
label define s1q15 12043505 `"Dengop"', modify
label define s1q15 12043506 `"Konimdo"', modify
label define s1q15 12043507 `"Selepet"', modify
label define s1q15 12043508 `"Indum 2"', modify
label define s1q15 12043509 `"Indum 1"', modify
label define s1q15 12043510 `"Weke"', modify
label define s1q15 12043511 `"Dollo"', modify
label define s1q15 12043512 `"Kamandu"', modify
label define s1q15 12043513 `"Gilang"', modify
label define s1q15 12043514 `"Hupat"', modify
label define s1q15 12043515 `"Tipsit"', modify
label define s1q15 12043516 `"Dengondo"', modify
label define s1q15 12043517 `"Bomu/Gotoro"', modify
label define s1q15 12043518 `"Iloko"', modify
label define s1q15 12043519 `"Kabwum Station"', modify
label define s1q15 12051682 `"Lae City"', modify
label define s1q15 12061701 `"Tapakainantu"', modify
label define s1q15 12061702 `"Imane"', modify
label define s1q15 12061703 `"Kusing"', modify
label define s1q15 12061704 `"Siaga"', modify
label define s1q15 12061705 `"Tumbuna"', modify
label define s1q15 12061706 `"Ngarowain"', modify
label define s1q15 12061707 `"Guruf"', modify
label define s1q15 12061708 `"Itsingants"', modify
label define s1q15 12061709 `"Antir"', modify
label define s1q15 12061710 `"Intoap"', modify
label define s1q15 12061711 `"Wampul"', modify
label define s1q15 12061712 `"Singas / Awan Singas"', modify
label define s1q15 12061713 `"Onga"', modify
label define s1q15 12061801 `"Ragiampun"', modify
label define s1q15 12061802 `"Waritzian"', modify
label define s1q15 12061803 `"Watarais"', modify
label define s1q15 12061804 `"Atzunas"', modify
label define s1q15 12061805 `"Marawasa"', modify
label define s1q15 12061806 `"Wankun"', modify
label define s1q15 12061807 `"Raginam"', modify
label define s1q15 12061808 `"Rumpa"', modify
label define s1q15 12061809 `"Yanuf"', modify
label define s1q15 12061810 `"Numbugu"', modify
label define s1q15 12061811 `"Ngarutzaniang"', modify
label define s1q15 12061812 `"Samaran"', modify
label define s1q15 12061813 `"Zumara"', modify
label define s1q15 12061814 `"Mayamzariang"', modify
label define s1q15 12061815 `"Tofmora"', modify
label define s1q15 12061816 `"Arifiran"', modify
label define s1q15 12061817 `"Dabu"', modify
label define s1q15 12061818 `"Zumim"', modify
label define s1q15 12061819 `"Antiragen"', modify
label define s1q15 12061820 `"Gandisap"', modify
label define s1q15 12061821 `"Sauruan"', modify
label define s1q15 12061822 `"Marangits"', modify
label define s1q15 12061823 `"Marangints"', modify
label define s1q15 12061824 `"Mangiang"', modify
label define s1q15 12061825 `"Binimamp"', modify
label define s1q15 12061826 `"Nasawasiang"', modify
label define s1q15 12061827 `"Sangan"', modify
label define s1q15 12061828 `"Wafibampun"', modify
label define s1q15 12061829 `"Zumangurun"', modify
label define s1q15 12061830 `"Mutzing Station"', modify
label define s1q15 12061901 `"Matak"', modify
label define s1q15 12061902 `"Mataya"', modify
label define s1q15 12061903 `"Guningwan"', modify
label define s1q15 12061904 `"Arawik"', modify
label define s1q15 12061905 `"Umbaku"', modify
label define s1q15 12061906 `"Yaparwguan"', modify
label define s1q15 12061907 `"Gwambongwak"', modify
label define s1q15 12061908 `"Sengapan"', modify
label define s1q15 12061909 `"Kubung"', modify
label define s1q15 12061910 `"Uyam"', modify
label define s1q15 12061911 `"Bumbum"', modify
label define s1q15 12061912 `"Daimsot"', modify
label define s1q15 12061913 `"Ewok"', modify
label define s1q15 12061914 `"Ginonga"', modify
label define s1q15 12061915 `"Kamang"', modify
label define s1q15 12061916 `"Gumia"', modify
label define s1q15 12061917 `"Daku"', modify
label define s1q15 12061918 `"Sukurum"', modify
label define s1q15 12061919 `"Som"', modify
label define s1q15 12061920 `"Ngariawang"', modify
label define s1q15 12072101 `"Engati"', modify
label define s1q15 12072102 `"Tsewi"', modify
label define s1q15 12072103 `"Umba"', modify
label define s1q15 12072104 `"Singeiapa"', modify
label define s1q15 12072105 `"Jipa"', modify
label define s1q15 12072106 `"Menya"', modify
label define s1q15 12072107 `"Yakwoi"', modify
label define s1q15 12072108 `"Longwi"', modify
label define s1q15 12072109 `"Ilbale"', modify
label define s1q15 12072110 `"Kwaplalim"', modify
label define s1q15 12072111 `"Helalapa"', modify
label define s1q15 12072112 `"Kainal"', modify
label define s1q15 12072113 `"Wanagapali"', modify
label define s1q15 12072114 `"Hartingli"', modify
label define s1q15 12072115 `"Ikumdi"', modify
label define s1q15 12072116 `"Menyamya Station"', modify
label define s1q15 12072201 `"Watama"', modify
label define s1q15 12072202 `"Hanjua"', modify
label define s1q15 12072203 `"Wauwoka"', modify
label define s1q15 12072204 `"Womei"', modify
label define s1q15 12072205 `"Tamoi"', modify
label define s1q15 12072206 `"Yakepa"', modify
label define s1q15 12072207 `"Akwanja"', modify
label define s1q15 12072208 `"Taupa"', modify
label define s1q15 12072209 `"Mabukapu"', modify
label define s1q15 12072210 `"Aiyogi"', modify
label define s1q15 12072211 `"Sikwong 1"', modify
label define s1q15 12072212 `"Sikwong 2"', modify
label define s1q15 12072213 `"Kapini"', modify
label define s1q15 12072214 `"Himerka"', modify
label define s1q15 12072215 `"Gebgya"', modify
label define s1q15 12073001 `"Otete"', modify
label define s1q15 12073002 `"Langamar"', modify
label define s1q15 12073003 `"Angenanga/Angewanga"', modify
label define s1q15 12073004 `"Hiakwata"', modify
label define s1q15 12073005 `"Komakwata"', modify
label define s1q15 12073006 `"Kamiakaka"', modify
label define s1q15 12073007 `"Okaneiwa"', modify
label define s1q15 12073008 `"Yamaiya"', modify
label define s1q15 12073009 `"Pasea"', modify
label define s1q15 12073010 `"Angeweto"', modify
label define s1q15 12073011 `"Aweaka"', modify
label define s1q15 12073012 `"Mekini"', modify
label define s1q15 12073013 `"Hiyewini"', modify
label define s1q15 12073014 `"Pawamanga"', modify
label define s1q15 12073015 `"Ainandoa"', modify
label define s1q15 12073402 `"Oiwa"', modify
label define s1q15 12073415 `"Haukini"', modify
label define s1q15 12073417 `"Wangini"', modify
label define s1q15 12073418 `"Bainu"', modify
label define s1q15 12073419 `"Poiyu"', modify
label define s1q15 12073421 `"Aseki Station"', modify
label define s1q15 12073424 `"Damnga"', modify
label define s1q15 12073425 `"Pakea"', modify
label define s1q15 12073426 `"Yangaiyu"', modify
label define s1q15 12073427 `"Wapa"', modify
label define s1q15 12073428 `"Tawa Station"', modify
label define s1q15 12073429 `"Yeva"', modify
label define s1q15 12073430 `"Kokea"', modify
label define s1q15 12073431 `"Wingia"', modify
label define s1q15 12082301 `"Tamigidu"', modify
label define s1q15 12082302 `"Boac"', modify
label define s1q15 12082303 `"Buingim"', modify
label define s1q15 12082304 `"Ee'c"', modify
label define s1q15 12082305 `"Wideru"', modify
label define s1q15 12082306 `"Bukawa"', modify
label define s1q15 12082307 `"Mundala"', modify
label define s1q15 12082308 `"Yambo"', modify
label define s1q15 12082309 `"Buhalu"', modify
label define s1q15 12082310 `"Waganluhu"', modify
label define s1q15 12082311 `"Apo"', modify
label define s1q15 12082312 `"Musom/Tale"', modify
label define s1q15 12082313 `"Situm"', modify
label define s1q15 12082314 `"Momolili"', modify
label define s1q15 12082401 `"Satukimo"', modify
label define s1q15 12082402 `"Yaquamu"', modify
label define s1q15 12082403 `"Awen"', modify
label define s1q15 12082404 `"Baindoang"', modify
label define s1q15 12082405 `"Kwambelem"', modify
label define s1q15 12082406 `"Kasanombe"', modify
label define s1q15 12082407 `"Karangandoang"', modify
label define s1q15 12082408 `"Kemen"', modify
label define s1q15 12082409 `"Momsalop"', modify
label define s1q15 12082410 `"Gwabadik"', modify
label define s1q15 12082411 `"Gawam"', modify
label define s1q15 12082412 `"Samanzing"', modify
label define s1q15 12082413 `"Hobu"', modify
label define s1q15 12082414 `"Sambuen"', modify
label define s1q15 12082501 `"Kokosan"', modify
label define s1q15 12082502 `"Saut"', modify
label define s1q15 12082503 `"Finungwa"', modify
label define s1q15 12082504 `"Lowai"', modify
label define s1q15 12082505 `"Rabisap"', modify
label define s1q15 12082506 `"Tinibi"', modify
label define s1q15 12082507 `"Sintogora"', modify
label define s1q15 12082508 `"Kisengan One"', modify
label define s1q15 12082509 `"Kisengan Two"', modify
label define s1q15 12082510 `"Gain"', modify
label define s1q15 12082511 `"Sadao"', modify
label define s1q15 12082512 `"Kuepunum"', modify
label define s1q15 12082513 `"Bandong"', modify
label define s1q15 12082514 `"Gusi"', modify
label define s1q15 12082515 `"Gamiki"', modify
label define s1q15 12082516 `"Pupuf"', modify
label define s1q15 12082517 `"Gumbum"', modify
label define s1q15 12082518 `"Gewak"', modify
label define s1q15 12092601 `"Gitua"', modify
label define s1q15 12092602 `"Kumukio"', modify
label define s1q15 12092603 `"Sialum"', modify
label define s1q15 12092604 `"Gitukia"', modify
label define s1q15 12092605 `"Kukuya"', modify
label define s1q15 12092606 `"Kangkeu"', modify
label define s1q15 12092607 `"Rua"', modify
label define s1q15 12092608 `"Nungen"', modify
label define s1q15 12092609 `"Kanome"', modify
label define s1q15 12092610 `"Ririwo"', modify
label define s1q15 12092611 `"Karako"', modify
label define s1q15 12092612 `"Zankoa"', modify
label define s1q15 12092613 `"Wandokai"', modify
label define s1q15 12092614 `"Walingai"', modify
label define s1q15 12092615 `"Rebafu"', modify
label define s1q15 12092616 `"Zangefifi"', modify
label define s1q15 12092617 `"Zuzumau"', modify
label define s1q15 12092618 `"Masa"', modify
label define s1q15 12092619 `"Kingarenau"', modify
label define s1q15 12092701 `"Lokep"', modify
label define s1q15 12092702 `"Masele"', modify
label define s1q15 12092703 `"Aimalu"', modify
label define s1q15 12092704 `"Aupwel"', modify
label define s1q15 12092705 `"Samanai"', modify
label define s1q15 12092706 `"Semo"', modify
label define s1q15 12092707 `"Pandamot"', modify
label define s1q15 12092708 `"Tagop"', modify
label define s1q15 12092709 `"Opai"', modify
label define s1q15 12092710 `"Bunsil"', modify
label define s1q15 12092711 `"Aronai"', modify
label define s1q15 12092712 `"Malai"', modify
label define s1q15 12092713 `"Tuam"', modify
label define s1q15 12092714 `"Mandok"', modify
label define s1q15 12092715 `"Giam"', modify
label define s1q15 12092716 `"Gune"', modify
label define s1q15 12092717 `"Lablab 1"', modify
label define s1q15 12092718 `"Marile"', modify
label define s1q15 12092719 `"Mabey"', modify
label define s1q15 12092720 `"Movi"', modify
label define s1q15 12092801 `"Yakawa"', modify
label define s1q15 12092802 `"Sio 2"', modify
label define s1q15 12092803 `"Sio 1"', modify
label define s1q15 12092804 `"Kulavi"', modify
label define s1q15 12092805 `"Wasu Station"', modify
label define s1q15 12092806 `"Kiari"', modify
label define s1q15 12092807 `"Weleki"', modify
label define s1q15 12092808 `"Towat"', modify
label define s1q15 12092809 `"Welowelo"', modify
label define s1q15 12092810 `"Singorokai"', modify
label define s1q15 12092811 `"Roinji"', modify
label define s1q15 12092812 `"Hungo"', modify
label define s1q15 12092813 `"Satop"', modify
label define s1q15 12092814 `"Wawet"', modify
label define s1q15 12092815 `"Domut"', modify
label define s1q15 12092816 `"Belombibi"', modify
label define s1q15 12092817 `"Karangan"', modify
label define s1q15 12092818 `"Niniea"', modify
label define s1q15 13010101 `"Ambana"', modify
label define s1q15 13010102 `"Lilau"', modify
label define s1q15 13010103 `"Gawat"', modify
label define s1q15 13010104 `"Wangor"', modify
label define s1q15 13010105 `"Suaru"', modify
label define s1q15 13010106 `"Dumudum"', modify
label define s1q15 13010107 `"Turutapa"', modify
label define s1q15 13010108 `"Urumarav"', modify
label define s1q15 13010109 `"Milalimuda"', modify
label define s1q15 13010110 `"Aidibal"', modify
label define s1q15 13010111 `"Turupuav"', modify
label define s1q15 13010112 `"Murusapa"', modify
label define s1q15 13010113 `"Wadaginam"', modify
label define s1q15 13010114 `"Sirikin"', modify
label define s1q15 13010115 `"Wagimuda"', modify
label define s1q15 13010116 `"Yavera"', modify
label define s1q15 13010117 `"Yakiba"', modify
label define s1q15 13010118 `"Mugumat"', modify
label define s1q15 13010119 `"Yoro Suvat"', modify
label define s1q15 13010120 `"Dugumor"', modify
label define s1q15 13010121 `"Busip Kalelap"', modify
label define s1q15 13010122 `"Simbine"', modify
label define s1q15 13010123 `"Malala Wakor"', modify
label define s1q15 13010124 `"Amiten"', modify
label define s1q15 13010125 `"Aketa"', modify
label define s1q15 13010126 `"Aleswaw"', modify
label define s1q15 13010127 `"Manugar"', modify
label define s1q15 13010128 `"Gugubar"', modify
label define s1q15 13010129 `"Erewanem"', modify
label define s1q15 13010130 `"Ulatapun"', modify
label define s1q15 13010131 `"Tarikapa"', modify
label define s1q15 13010132 `"Muaka"', modify
label define s1q15 13010133 `"Korak"', modify
label define s1q15 13010134 `"Ulingan"', modify
label define s1q15 13010135 `"Toto"', modify
label define s1q15 13010136 `"Medebur"', modify
label define s1q15 13010137 `"Mereman"', modify
label define s1q15 13010201 `"Baliau Ward"', modify
label define s1q15 13010202 `"Dangale"', modify
label define s1q15 13010203 `"Koalang"', modify
label define s1q15 13010204 `"Boakure"', modify
label define s1q15 13010205 `"Abaria"', modify
label define s1q15 13010206 `"Warisi"', modify
label define s1q15 13010207 `"Dugulaba"', modify
label define s1q15 13010208 `"Budua"', modify
label define s1q15 13010209 `"Madauri"', modify
label define s1q15 13010210 `"Waia"', modify
label define s1q15 13010211 `"Jogari"', modify
label define s1q15 13010212 `"Yassa"', modify
label define s1q15 13010213 `"Kuluguma"', modify
label define s1q15 13010214 `"Boda"', modify
label define s1q15 13010215 `"Boisa"', modify
label define s1q15 13010301 `"Marangis"', modify
label define s1q15 13010302 `"Kaiyan"', modify
label define s1q15 13010303 `"Boroi"', modify
label define s1q15 13010304 `"Buliva"', modify
label define s1q15 13010305 `"Daiden"', modify
label define s1q15 13010306 `"Dongan"', modify
label define s1q15 13010307 `"Awar"', modify
label define s1q15 13010308 `"Nubia"', modify
label define s1q15 13010309 `"Birap"', modify
label define s1q15 13010310 `"Rugusak"', modify
label define s1q15 13010311 `"Ambu"', modify
label define s1q15 13010313 `"Sepa"', modify
label define s1q15 13010314 `"Rugasak"', modify
label define s1q15 13010315 `"Banag"', modify
label define s1q15 13010316 `"Giri Tung"', modify
label define s1q15 13010317 `"Damangap"', modify
label define s1q15 13010318 `"Kumnung"', modify
label define s1q15 13010319 `"Minung"', modify
label define s1q15 13010320 `"Kuarak"', modify
label define s1q15 13010321 `"Mikarew"', modify
label define s1q15 13010322 `"Abegini"', modify
label define s1q15 13010323 `"Dinam Adui"', modify
label define s1q15 13010324 `"Apengan"', modify
label define s1q15 13010325 `"Ariangon"', modify
label define s1q15 13010326 `"Amba Arep"', modify
label define s1q15 13010327 `"Aringen Gun"', modify
label define s1q15 13010328 `"Dimuk Sirin"', modify
label define s1q15 13010329 `"Giar Wazamb"', modify
label define s1q15 13010330 `"Andeamarup"', modify
label define s1q15 13010331 `"Duapmung"', modify
label define s1q15 13010332 `"Andarum"', modify
label define s1q15 13010333 `"Ingamuk"', modify
label define s1q15 13010334 `"Barit"', modify
label define s1q15 13010335 `"Kayoma"', modify
label define s1q15 13010336 `"Bang Wokam"', modify
label define s1q15 13010337 `"Sanai Taringi"', modify
label define s1q15 13010338 `"Naupi"', modify
label define s1q15 13010339 `"Gwaia Akurai"', modify
label define s1q15 13010380 `"Bogia Urban"', modify
label define s1q15 13020402 `"Furan / Sisiak"', modify
label define s1q15 13020403 `"Korong / Opi"', modify
label define s1q15 13020404 `"Kamba / Kuris"', modify
label define s1q15 13020405 `"Siar / Wadan"', modify
label define s1q15 13020406 `"Riwo / Nagada"', modify
label define s1q15 13020407 `"Amron / Baitabag"', modify
label define s1q15 13020408 `"Budad Haven"', modify
label define s1q15 13020409 `"Gegeri Wangar"', modify
label define s1q15 13020410 `"Ward 10"', modify
label define s1q15 13020411 `"Bagupi / Saruga"', modify
label define s1q15 13020412 `"Abar / Labting"', modify
label define s1q15 13020413 `"Baiteta / Hipondik"', modify
label define s1q15 13020414 `"Balima / Kusubar"', modify
label define s1q15 13020415 `"Aiyap / Malac"', modify
label define s1q15 13020416 `"Sein"', modify
label define s1q15 13020417 `"Bahor Sahgala"', modify
label define s1q15 13020418 `"Ward 18"', modify
label define s1q15 13020419 `"Amele / Omuru"', modify
label define s1q15 13020420 `"Bau / Umun"', modify
label define s1q15 13020421 `"Bemahal / Fulumu"', modify
label define s1q15 13020422 `"Arar/ Maneb"', modify
label define s1q15 13020423 `"Asikan/ Atu"', modify
label define s1q15 13020581 `"Madang Urban"', modify
label define s1q15 13020601 `"Melowaba"', modify
label define s1q15 13020602 `"Gumaru Mawan"', modify
label define s1q15 13020603 `"Amaimon"', modify
label define s1q15 13020604 `"Baisarik"', modify
label define s1q15 13020605 `"Bemari  Waguma"', modify
label define s1q15 13020606 `"Garinam"', modify
label define s1q15 13020607 `"Barum"', modify
label define s1q15 13020608 `"Buroa"', modify
label define s1q15 13020609 `"Butade"', modify
label define s1q15 13020610 `"Kagi"', modify
label define s1q15 13020611 `"Ensuda"', modify
label define s1q15 13020612 `"Bai"', modify
label define s1q15 13020613 `"Dawa Bigawa"', modify
label define s1q15 13020614 `"Babaran Imam"', modify
label define s1q15 13020615 `"Kosilanta"', modify
label define s1q15 13020616 `"Abiya"', modify
label define s1q15 13030701 `"Gokta"', modify
label define s1q15 13030702 `"Jakipuat"', modify
label define s1q15 13030703 `"Atiapi"', modify
label define s1q15 13030704 `"Diam"', modify
label define s1q15 13030705 `"Moibu"', modify
label define s1q15 13030706 `"Gragebu"', modify
label define s1q15 13030707 `"Nodabu"', modify
label define s1q15 13030708 `"Paibu"', modify
label define s1q15 13030709 `"Watabu"', modify
label define s1q15 13030710 `"Grengabu"', modify
label define s1q15 13030711 `"Chungribu"', modify
label define s1q15 13030712 `"Limbubu"', modify
label define s1q15 13030713 `"Kwanga"', modify
label define s1q15 13030714 `"Askunka"', modify
label define s1q15 13030715 `"Misingi"', modify
label define s1q15 13030716 `"Nambringi"', modify
label define s1q15 13030717 `"Bumbera"', modify
label define s1q15 13030718 `"Bunungum"', modify
label define s1q15 13030719 `"Gosingi"', modify
label define s1q15 13030720 `"Brokoto"', modify
label define s1q15 13030721 `"Akurukai"', modify
label define s1q15 13030722 `"Wawapi"', modify
label define s1q15 13030723 `"Ipokondor"', modify
label define s1q15 13030724 `"Rarapi"', modify
label define s1q15 13030725 `"Awam"', modify
label define s1q15 13030726 `"Akavangu"', modify
label define s1q15 13030727 `"Astangu"', modify
label define s1q15 13030728 `"Atemble"', modify
label define s1q15 13030729 `"Iporaitz"', modify
label define s1q15 13030730 `"Iragarat"', modify
label define s1q15 13030731 `"Anamunk"', modify
label define s1q15 13030732 `"Apanam"', modify
label define s1q15 13030734 `"Sotobu"', modify
label define s1q15 13030801 `"Ingawaia"', modify
label define s1q15 13030802 `"Bogen"', modify
label define s1q15 13030803 `"Osum"', modify
label define s1q15 13030804 `"Avunmakai"', modify
label define s1q15 13030805 `"Evuar"', modify
label define s1q15 13030806 `"Mandugar"', modify
label define s1q15 13030807 `"Arimbugor"', modify
label define s1q15 13030808 `"Kisila / Simbar"', modify
label define s1q15 13030809 `"Iabaranga"', modify
label define s1q15 13030810 `"Kangarangat"', modify
label define s1q15 13030811 `"Yamamuk"', modify
label define s1q15 13030812 `"Inasi"', modify
label define s1q15 13030813 `"Amjaivuvu"', modify
label define s1q15 13030814 `"Angasa"', modify
label define s1q15 13030815 `"Kaibugu"', modify
label define s1q15 13030816 `"Ivarai"', modify
label define s1q15 13030817 `"Kinbugor"', modify
label define s1q15 13030818 `"Aragnam"', modify
label define s1q15 13030819 `"Ambok"', modify
label define s1q15 13030820 `"Kamambu"', modify
label define s1q15 13030821 `"Sangur Sangur"', modify
label define s1q15 13030822 `"Munimatamam"', modify
label define s1q15 13030823 `"Atitau"', modify
label define s1q15 13030824 `"Arimatau"', modify
label define s1q15 13030825 `"Abasakul"', modify
label define s1q15 13030826 `"Kokomasak"', modify
label define s1q15 13030904 `"Ainong"', modify
label define s1q15 13030905 `"Momuk"', modify
label define s1q15 13030906 `"Kaironk"', modify
label define s1q15 13030907 `"Fongoi"', modify
label define s1q15 13030908 `"Fundum"', modify
label define s1q15 13030909 `"Gubun"', modify
label define s1q15 13030910 `"Nugunt"', modify
label define s1q15 13030911 `"Koki"', modify
label define s1q15 13030912 `"Yambunglem"', modify
label define s1q15 13030913 `"Kerevin"', modify
label define s1q15 13030914 `"Kurumdek"', modify
label define s1q15 13030915 `"Kandum"', modify
label define s1q15 13030916 `"Tinam"', modify
label define s1q15 13030917 `"Aigram"', modify
label define s1q15 13030918 `"Kampaying"', modify
label define s1q15 13030919 `"Babaimp"', modify
label define s1q15 13030920 `"Kumbruf"', modify
label define s1q15 13030921 `"Tsungup"', modify
label define s1q15 13031701 `"Salemp"', modify
label define s1q15 13031702 `"Sonvak"', modify
label define s1q15 13031703 `"Aranam"', modify
label define s1q15 13031722 `"Hangaple"', modify
label define s1q15 13031723 `"Aradip"', modify
label define s1q15 13031724 `"Sangapi"', modify
label define s1q15 13031725 `"Dangu"', modify
label define s1q15 13031726 `"Gebrau"', modify
label define s1q15 13031727 `"Tingi"', modify
label define s1q15 13031728 `"Yilu"', modify
label define s1q15 13031729 `"Mamusi"', modify
label define s1q15 13031730 `"Fitako"', modify
label define s1q15 13041001 `"Kul"', modify
label define s1q15 13041002 `"Bangri"', modify
label define s1q15 13041003 `"Bang"', modify
label define s1q15 13041004 `"Bongu"', modify
label define s1q15 13041005 `"Boram"', modify
label define s1q15 13041006 `"Male"', modify
label define s1q15 13041007 `"Lalok"', modify
label define s1q15 13041008 `"Kulel"', modify
label define s1q15 13041009 `"Saipa"', modify
label define s1q15 13041010 `"Bom"', modify
label define s1q15 13041011 `"Jamjam"', modify
label define s1q15 13041012 `"Kwato"', modify
label define s1q15 13041013 `"Erima"', modify
label define s1q15 13041014 `"Ato"', modify
label define s1q15 13041015 `"Ileg"', modify
label define s1q15 13041101 `"Gurumbo"', modify
label define s1q15 13041102 `"Mungoui"', modify
label define s1q15 13041103 `"Ranara"', modify
label define s1q15 13041104 `"Boro"', modify
label define s1q15 13041105 `"Tauta"', modify
label define s1q15 13041106 `"Barim"', modify
label define s1q15 13041107 `"Goiro"', modify
label define s1q15 13041108 `"Niningo"', modify
label define s1q15 13041109 `"Numbaiya"', modify
label define s1q15 13041110 `"Gomumu"', modify
label define s1q15 13041111 `"Saranga"', modify
label define s1q15 13041112 `"Serengo"', modify
label define s1q15 13041113 `"Kikipe"', modify
label define s1q15 13041114 `"Wamunde"', modify
label define s1q15 13041115 `"Wari"', modify
label define s1q15 13041116 `"Butemu"', modify
label define s1q15 13041117 `"Durukopo"', modify
label define s1q15 13041118 `"Senei"', modify
label define s1q15 13041119 `"Gumbarami"', modify
label define s1q15 13041120 `"Sewe"', modify
label define s1q15 13041201 `"Bonga"', modify
label define s1q15 13041204 `"Kepolak"', modify
label define s1q15 13041205 `"Baru"', modify
label define s1q15 13041206 `"Mamgak"', modify
label define s1q15 13041207 `"Mur"', modify
label define s1q15 13041208 `"Umboldi"', modify
label define s1q15 13041209 `"Kakimar"', modify
label define s1q15 13041210 `"Saidor"', modify
label define s1q15 13041211 `"Yaimas"', modify
label define s1q15 13041212 `"Waibol"', modify
label define s1q15 13041213 `"Biliau"', modify
label define s1q15 13041214 `"Sibog"', modify
label define s1q15 13041215 `"Suri"', modify
label define s1q15 13041216 `"Bagalawa"', modify
label define s1q15 13041217 `"Lamtup"', modify
label define s1q15 13041218 `"Maibang"', modify
label define s1q15 13041219 `"Yorkia"', modify
label define s1q15 13041220 `"Sari"', modify
label define s1q15 13041221 `"Sorang"', modify
label define s1q15 13041222 `"Kiambaui"', modify
label define s1q15 13041223 `"Matako"', modify
label define s1q15 13041224 `"Gogou"', modify
label define s1q15 13041225 `"Sarakiri"', modify
label define s1q15 13041226 `"Kwongo"', modify
label define s1q15 13041227 `"Wado"', modify
label define s1q15 13041228 `"Simimididi"', modify
label define s1q15 13041229 `"Wongetuo"', modify
label define s1q15 13041230 `"Ganglau"', modify
label define s1q15 13041231 `"Orinma"', modify
label define s1q15 13041232 `"Mebu"', modify
label define s1q15 13041233 `"Batoto"', modify
label define s1q15 13041234 `"Matafun"', modify
label define s1q15 13041235 `"Bok"', modify
label define s1q15 13041236 `"Malala"', modify
label define s1q15 13041237 `"Ward 37"', modify
label define s1q15 13041238 `"Ward 38"', modify
label define s1q15 13041239 `"Ward 39"', modify
label define s1q15 13041240 `"Ward 40"', modify
label define s1q15 13041241 `"Ward 41"', modify
label define s1q15 13041242 `"Ward 42"', modify
label define s1q15 13041802 `"Tapen"', modify
label define s1q15 13041803 `"Gabutamon"', modify
label define s1q15 13051301 `"Yau/Badilu"', modify
label define s1q15 13051302 `"Matiu"', modify
label define s1q15 13051303 `"Tarak"', modify
label define s1q15 13051304 `"Kaviak"', modify
label define s1q15 13051305 `"Kinim Station"', modify
label define s1q15 13051306 `"Narer"', modify
label define s1q15 13051307 `"Urugen"', modify
label define s1q15 13051308 `"Bangme/Langlang"', modify
label define s1q15 13051309 `"Gial"', modify
label define s1q15 13051310 `"Tugutugu"', modify
label define s1q15 13051311 `"Dimer"', modify
label define s1q15 13051312 `"Kaul 1"', modify
label define s1q15 13051313 `"Kaul 3"', modify
label define s1q15 13051314 `"Mapor"', modify
label define s1q15 13051315 `"Muluk"', modify
label define s1q15 13051316 `"Kubam"', modify
label define s1q15 13051317 `"Katom"', modify
label define s1q15 13051318 `"Pain"', modify
label define s1q15 13051319 `"Komoria"', modify
label define s1q15 13051320 `"Dangsai"', modify
label define s1q15 13051321 `"Biu"', modify
label define s1q15 13051322 `"Did"', modify
label define s1q15 13051323 `"Boroman"', modify
label define s1q15 13051324 `"Kurum"', modify
label define s1q15 13051325 `"Liloi"', modify
label define s1q15 13051326 `"Marup"', modify
label define s1q15 13051327 `"Kevasop"', modify
label define s1q15 13051328 `"Mangar"', modify
label define s1q15 13051329 `"Bafor"', modify
label define s1q15 13051330 `"Kuduk"', modify
label define s1q15 13051331 `"Bujon/Kurumtaur"', modify
label define s1q15 13051332 `"Marangis/Mom"', modify
label define s1q15 13051333 `"Keng/Mater"', modify
label define s1q15 13051401 `"Bunbun"', modify
label define s1q15 13051402 `"Erenduk"', modify
label define s1q15 13051403 `"Murukanam"', modify
label define s1q15 13051404 `"Malas"', modify
label define s1q15 13051405 `"Imbab"', modify
label define s1q15 13051406 `"Mirap"', modify
label define s1q15 13051407 `"Karkum"', modify
label define s1q15 13051408 `"Sarang"', modify
label define s1q15 13051409 `"Basken"', modify
label define s1q15 13051410 `"Budum"', modify
label define s1q15 13051411 `"Garup"', modify
label define s1q15 13051412 `"Megiar"', modify
label define s1q15 13051413 `"Biranis"', modify
label define s1q15 13051414 `"Liksal"', modify
label define s1q15 13051415 `"Barag / Aronis"', modify
label define s1q15 13051416 `"Bunu No.1"', modify
label define s1q15 13051417 `"Kudas"', modify
label define s1q15 13051418 `"Wasab"', modify
label define s1q15 13051419 `"Burbura"', modify
label define s1q15 13051420 `"Bagildik"', modify
label define s1q15 13051421 `"Deda"', modify
label define s1q15 13051422 `"Bomasse"', modify
label define s1q15 13051423 `"Bandimfok"', modify
label define s1q15 13051424 `"Asiwo"', modify
label define s1q15 13051425 `"Abab"', modify
label define s1q15 13051426 `"Dimert"', modify
label define s1q15 13051427 `"Bilakura"', modify
label define s1q15 13051428 `"Embor"', modify
label define s1q15 13051429 `"Perene"', modify
label define s1q15 13051430 `"Katekot"', modify
label define s1q15 13051431 `"Hinihon"', modify
label define s1q15 13061501 `"Bundi-kara"', modify
label define s1q15 13061502 `"Snopass"', modify
label define s1q15 13061503 `"Bononi"', modify
label define s1q15 13061504 `"Imuri"', modify
label define s1q15 13061505 `"Gobug-Agu"', modify
label define s1q15 13061506 `"Yandara"', modify
label define s1q15 13061507 `"Kindaukevi"', modify
label define s1q15 13061508 `"Karamuke"', modify
label define s1q15 13061509 `"Marum"', modify
label define s1q15 13061510 `"Mokinangi"', modify
label define s1q15 13061511 `"Guyebi"', modify
label define s1q15 13061512 `"Emegari"', modify
label define s1q15 13061513 `"Kobum"', modify
label define s1q15 13061514 `"Mondinongra"', modify
label define s1q15 13061515 `"Pupuneri"', modify
label define s1q15 13061516 `"Biom"', modify
label define s1q15 13061517 `"Promisi"', modify
label define s1q15 13061518 `"Brahman"', modify
label define s1q15 13061519 `"Tauya"', modify
label define s1q15 13061520 `"Safi"', modify
label define s1q15 13061521 `"Pendiva"', modify
label define s1q15 13061522 `"Krumbukari"', modify
label define s1q15 13061601 `"Bumbu"', modify
label define s1q15 13061606 `"Sankain"', modify
label define s1q15 13061607 `"Dumpu"', modify
label define s1q15 13061608 `"Kesawai"', modify
label define s1q15 13061609 `"Aliveti"', modify
label define s1q15 13061610 `"Koropa"', modify
label define s1q15 13061611 `"Sausi"', modify
label define s1q15 13061612 `"Korona"', modify
label define s1q15 13061613 `"Yakumbu"', modify
label define s1q15 13061614 `"Walium"', modify
label define s1q15 13061615 `"Kuragina"', modify
label define s1q15 13061616 `"Waput"', modify
label define s1q15 13061617 `"Puksak"', modify
label define s1q15 13061618 `"Naru"', modify
label define s1q15 13061619 `"Somau"', modify
label define s1q15 13061620 `"Mopo"', modify
label define s1q15 13061621 `"Animinik"', modify
label define s1q15 13061622 `"Negeri"', modify
label define s1q15 13061623 `"Begesin"', modify
label define s1q15 13061624 `"Koinegur"', modify
label define s1q15 13061625 `"Baisop"', modify
label define s1q15 13061626 `"Kunduk"', modify
label define s1q15 13061627 `"Eunime"', modify
label define s1q15 13061628 `"Komas"', modify
label define s1q15 13061629 `"Igoi"', modify
label define s1q15 13061630 `"Usino Station"', modify
label define s1q15 13061631 `"Boko"', modify
label define s1q15 13061632 `"Garaligut"', modify
label define s1q15 13061633 `"Musak"', modify
label define s1q15 13061634 `"Kukapang"', modify
label define s1q15 13061683 `"Ramu Sugar Urban"', modify
label define s1q15 13061935 `"Aingdai /Forogo"', modify
label define s1q15 13061936 `"Ambisiba"', modify
label define s1q15 13061937 `"Kenaint"', modify
label define s1q15 13061938 `"Kinibong"', modify
label define s1q15 13061939 `"Gai"', modify
label define s1q15 13061940 `"Bank"', modify
label define s1q15 13061941 `"Useruk"', modify
label define s1q15 13061943 `"Kwaringiri"', modify
label define s1q15 13061944 `"Garisakan / Umerum"', modify
label define s1q15 13061945 `"Gunts"', modify
label define s1q15 13061947 `"Kombaku"', modify
label define s1q15 14010101 `"Ambunti"', modify
label define s1q15 14010102 `"Bangus"', modify
label define s1q15 14010104 `"Beglam"', modify
label define s1q15 14010105 `"Tangujamb"', modify
label define s1q15 14010106 `"Singiok"', modify
label define s1q15 14010107 `"Amaki 1"', modify
label define s1q15 14010108 `"Ablatak"', modify
label define s1q15 14010109 `"Waiwos"', modify
label define s1q15 14010110 `"Bu-Ur"', modify
label define s1q15 14010111 `"Warsei"', modify
label define s1q15 14010112 `"Ambuken"', modify
label define s1q15 14010113 `"Tauri"', modify
label define s1q15 14010114 `"Oum 1"', modify
label define s1q15 14010115 `"Oum 2"', modify
label define s1q15 14010116 `"Sanapian"', modify
label define s1q15 14010117 `"Hauna"', modify
label define s1q15 14010118 `"Waskuk"', modify
label define s1q15 14010119 `"Kupkain"', modify
label define s1q15 14010120 `"Swagap 1"', modify
label define s1q15 14010121 `"Baku"', modify
label define s1q15 14010122 `"Yessan"', modify
label define s1q15 14010123 `"Prukunawi"', modify
label define s1q15 14010124 `"Yambun"', modify
label define s1q15 14010125 `"Malu"', modify
label define s1q15 14010126 `"Yerakai"', modify
label define s1q15 14010127 `"Garamambu"', modify
label define s1q15 14010128 `"Yauambak"', modify
label define s1q15 14010129 `"Avatip"', modify
label define s1q15 14010180 `"Ambunti Urban"', modify
label define s1q15 14010201 `"Tumam"', modify
label define s1q15 14010202 `"Moihwak"', modify
label define s1q15 14010203 `"Musungua"', modify
label define s1q15 14010204 `"Taihunge"', modify
label define s1q15 14010205 `"Mosinau"', modify
label define s1q15 14010206 `"Prombil"', modify
label define s1q15 14010207 `"Missim"', modify
label define s1q15 14010208 `"Pelnandu"', modify
label define s1q15 14010209 `"Musindai"', modify
label define s1q15 14010210 `"Bana"', modify
label define s1q15 14010211 `"Hambini"', modify
label define s1q15 14010212 `"Waringame"', modify
label define s1q15 14010213 `"Selni"', modify
label define s1q15 14010214 `"Aresili"', modify
label define s1q15 14010215 `"Whaleng"', modify
label define s1q15 14010216 `"Yawatong"', modify
label define s1q15 14010217 `"Lainimguap"', modify
label define s1q15 14010218 `"Krunguanam"', modify
label define s1q15 14010219 `"Yakrumbok"', modify
label define s1q15 14010220 `"King"', modify
label define s1q15 14010221 `"Kofem"', modify
label define s1q15 14010222 `"Sakap"', modify
label define s1q15 14010223 `"Makumauip"', modify
label define s1q15 14010224 `"Tong"', modify
label define s1q15 14010225 `"Kumbun"', modify
label define s1q15 14010226 `"Miringe"', modify
label define s1q15 14010227 `"Yawerng"', modify
label define s1q15 14010228 `"Yambes"', modify
label define s1q15 14010229 `"Waim/Saiweep"', modify
label define s1q15 14010230 `"Moseng"', modify
label define s1q15 14010231 `"Pagilo"', modify
label define s1q15 14010232 `"Luwaite"', modify
label define s1q15 14010301 `"Apangai"', modify
label define s1q15 14010302 `"Yambanakor 1"', modify
label define s1q15 14010303 `"Yambinakor 2"', modify
label define s1q15 14010304 `"Asanakor"', modify
label define s1q15 14010305 `"Inakor"', modify
label define s1q15 14010306 `"Apos"', modify
label define s1q15 14010307 `"Daina"', modify
label define s1q15 14010308 `"Masalagar"', modify
label define s1q15 14010309 `"Wasambu"', modify
label define s1q15 14010310 `"Bongomasi"', modify
label define s1q15 14010311 `"Wahaukia"', modify
label define s1q15 14010312 `"Bongos"', modify
label define s1q15 14010313 `"Kuyor"', modify
label define s1q15 14010314 `"Kuatengisi"', modify
label define s1q15 14010315 `"Mamsi"', modify
label define s1q15 14010316 `"Kubriwat 1"', modify
label define s1q15 14010317 `"Kubriwat 2"', modify
label define s1q15 14010318 `"Tau 1"', modify
label define s1q15 14010319 `"Tau 2"', modify
label define s1q15 14010320 `"Wamenokor"', modify
label define s1q15 14010401 `"Hotmin"', modify
label define s1q15 14010402 `"Burmai"', modify
label define s1q15 14010403 `"Arai"', modify
label define s1q15 14010404 `"Nino"', modify
label define s1q15 14010405 `"Itelinu"', modify
label define s1q15 14010406 `"Samo"', modify
label define s1q15 14010407 `"Painum"', modify
label define s1q15 14010408 `"Wanium"', modify
label define s1q15 14010409 `"Aumi"', modify
label define s1q15 14010410 `"Pekwei"', modify
label define s1q15 14010411 `"Wanamoi"', modify
label define s1q15 14010412 `"Waniap"', modify
label define s1q15 14010413 `"Kavia"', modify
label define s1q15 14010414 `"Ama"', modify
label define s1q15 14010415 `"Yenuai"', modify
label define s1q15 14010416 `"Panawai"', modify
label define s1q15 14010417 `"Imombi"', modify
label define s1q15 14010418 `"Mowi"', modify
label define s1q15 14010419 `"Iniok"', modify
label define s1q15 14010420 `"Paupe"', modify
label define s1q15 14010421 `"Oum 3"', modify
label define s1q15 14010422 `"Walio"', modify
label define s1q15 14010423 `"Nein"', modify
label define s1q15 14010424 `"Nekiei/Wusol"', modify
label define s1q15 14010425 `"Masuwari"', modify
label define s1q15 14010426 `"Sio"', modify
label define s1q15 14010427 `"Hanasi"', modify
label define s1q15 14010428 `"Moropote"', modify
label define s1q15 14010429 `"Maposi"', modify
label define s1q15 14010430 `"Lariaso"', modify
label define s1q15 14010431 `"Yabatawe"', modify
label define s1q15 14010432 `"Sowano"', modify
label define s1q15 14010433 `"Bitara"', modify
label define s1q15 14010434 `"Kagiru"', modify
label define s1q15 14010435 `"Begapuki"', modify
label define s1q15 14010436 `"Wagu"', modify
label define s1q15 14010437 `"Niksek/Paka"', modify
label define s1q15 14010438 `"Gahom"', modify
label define s1q15 14020501 `"Changriwa"', modify
label define s1q15 14020502 `"Marambao"', modify
label define s1q15 14020503 `"Kanduanum"', modify
label define s1q15 14020504 `"Krinjambi"', modify
label define s1q15 14020505 `"Tambari"', modify
label define s1q15 14020506 `"Agrumara"', modify
label define s1q15 14020507 `"Yuarma"', modify
label define s1q15 14020508 `"Mundomundo"', modify
label define s1q15 14020509 `"Kambrindo"', modify
label define s1q15 14020510 `"Moim"', modify
label define s1q15 14020511 `"Pinang"', modify
label define s1q15 14020512 `"Magendo 1"', modify
label define s1q15 14020513 `"Magendo 2"', modify
label define s1q15 14020515 `"Ex Service Camp"', modify
label define s1q15 14020516 `"Angoram Village"', modify
label define s1q15 14020517 `"Gavieng Resett 1"', modify
label define s1q15 14020518 `"Gavieng Resett 2"', modify
label define s1q15 14020519 `"Gavieng Resett 3"', modify
label define s1q15 14020520 `"Gavieng Resett 4"', modify
label define s1q15 14020521 `"Tambunum"', modify
label define s1q15 14020522 `"Wombun"', modify
label define s1q15 14020523 `"Timbunke"', modify
label define s1q15 14020524 `"Angriman"', modify
label define s1q15 14020525 `"Mindimbit"', modify
label define s1q15 14020526 `"Kamanimbit"', modify
label define s1q15 14020527 `"Kararau"', modify
label define s1q15 14020528 `"Timboli"', modify
label define s1q15 14020529 `"Indigum"', modify
label define s1q15 14020530 `"Chikinumbu"', modify
label define s1q15 14020531 `"Chimbian"', modify
label define s1q15 14020532 `"Saui"', modify
label define s1q15 14020533 `"Kingavi"', modify
label define s1q15 14020534 `"Koiwat"', modify
label define s1q15 14020535 `"Paimbit"', modify
label define s1q15 14020581 `"Angoram Urban"', modify
label define s1q15 14020601 `"Masandanai"', modify
label define s1q15 14020602 `"Kaiwaria"', modify
label define s1q15 14020603 `"Manjamai"', modify
label define s1q15 14020604 `"Konmei"', modify
label define s1q15 14020605 `"Ambonwari"', modify
label define s1q15 14020606 `"Imanmeri"', modify
label define s1q15 14020607 `"Kanjimei"', modify
label define s1q15 14020608 `"Kundiman"', modify
label define s1q15 14020609 `"Yimas"', modify
label define s1q15 14020610 `"Awim"', modify
label define s1q15 14020611 `"Yamandim"', modify
label define s1q15 14020612 `"Imboin"', modify
label define s1q15 14020613 `"Amongabi"', modify
label define s1q15 14020614 `"Chimbut"', modify
label define s1q15 14020615 `"Sikalum"', modify
label define s1q15 14020616 `"Yanitabak"', modify
label define s1q15 14020617 `"Latoma"', modify
label define s1q15 14020618 `"Malamata"', modify
label define s1q15 14020619 `"Kotkot"', modify
label define s1q15 14020620 `"Mamri"', modify
label define s1q15 14020621 `"Sangriman"', modify
label define s1q15 14020622 `"Tungimbit"', modify
label define s1q15 14020623 `"Kambraman"', modify
label define s1q15 14020624 `"Kraimbit"', modify
label define s1q15 14020625 `"Kaningara"', modify
label define s1q15 14020626 `"Govanmas"', modify
label define s1q15 14020627 `"Anganambai"', modify
label define s1q15 14020628 `"Tarakai"', modify
label define s1q15 14020629 `"Meska"', modify
label define s1q15 14020630 `"Bisorio"', modify
label define s1q15 14020701 `"Chimundo"', modify
label define s1q15 14020702 `"Kambot"', modify
label define s1q15 14020705 `"Bobten"', modify
label define s1q15 14020706 `"Korokopa"', modify
label define s1q15 14020707 `"Pusyten"', modify
label define s1q15 14020708 `"Kekten"', modify
label define s1q15 14020709 `"Buten"', modify
label define s1q15 14020710 `"Yemen"', modify
label define s1q15 14020711 `"Manu"', modify
label define s1q15 14020712 `"Kambugu"', modify
label define s1q15 14020713 `"Pamban"', modify
label define s1q15 14020714 `"Bopaten"', modify
label define s1q15 14020715 `"Langam"', modify
label define s1q15 14020716 `"Mongol"', modify
label define s1q15 14020717 `"Wom"', modify
label define s1q15 14020718 `"Raten"', modify
label define s1q15 14020719 `"Ketro/Samban"', modify
label define s1q15 14020720 `"Baniamta"', modify
label define s1q15 14020721 `"Kamen"', modify
label define s1q15 14020722 `"Marua"', modify
label define s1q15 14020723 `"Yanboe"', modify
label define s1q15 14020724 `"Nainten"', modify
label define s1q15 14020725 `"Yar"', modify
label define s1q15 14020726 `"Bagaram"', modify
label define s1q15 14020727 `"Kivim"', modify
label define s1q15 14020728 `"Longwuk"', modify
label define s1q15 14020729 `"Mungum"', modify
label define s1q15 14020730 `"Mingnias"', modify
label define s1q15 14020731 `"Togo"', modify
label define s1q15 14020732 `"Monjito"', modify
label define s1q15 14020733 `"Likan"', modify
label define s1q15 14020734 `"Klorowom"', modify
label define s1q15 14020735 `"Sori"', modify
label define s1q15 14020736 `"Paniten"', modify
label define s1q15 14020737 `"Pataka"', modify
label define s1q15 14020738 `"Mui"', modify
label define s1q15 14020801 `"Kasmin  2"', modify
label define s1q15 14020802 `"Kasmin 1"', modify
label define s1q15 14020803 `"Mansep"', modify
label define s1q15 14020804 `"Ariapan"', modify
label define s1q15 14020805 `"Boik"', modify
label define s1q15 14020806 `"Kis"', modify
label define s1q15 14020807 `"Kaup"', modify
label define s1q15 14020808 `"Murik"', modify
label define s1q15 14020809 `"Darapap"', modify
label define s1q15 14020810 `"Karau"', modify
label define s1q15 14020811 `"Mendam"', modify
label define s1q15 14020812 `"Bin"', modify
label define s1q15 14020813 `"Suk"', modify
label define s1q15 14020814 `"Imbandomarienberg"', modify
label define s1q15 14020815 `"Mamber"', modify
label define s1q15 14020816 `"Watam"', modify
label define s1q15 14020817 `"Kopar"', modify
label define s1q15 14020818 `"Mabuk"', modify
label define s1q15 14020819 `"Gapun"', modify
label define s1q15 14020820 `"Arango"', modify
label define s1q15 14020821 `"Ombos"', modify
label define s1q15 14020822 `"Ormai"', modify
label define s1q15 14020823 `"Jangit"', modify
label define s1q15 14020824 `"Manimong"', modify
label define s1q15 14020825 `"Murken"', modify
label define s1q15 14020826 `"Pokran"', modify
label define s1q15 14020827 `"Jeta"', modify
label define s1q15 14020828 `"Binam"', modify
label define s1q15 14020829 `"Pankin"', modify
label define s1q15 14020901 `"Kundima"', modify
label define s1q15 14020902 `"Aragunum"', modify
label define s1q15 14020903 `"Saparu"', modify
label define s1q15 14020904 `"Kinakaten"', modify
label define s1q15 14020905 `"Akuran"', modify
label define s1q15 14020906 `"Branda"', modify
label define s1q15 14020907 `"Biwat"', modify
label define s1q15 14020908 `"Muruat"', modify
label define s1q15 14020909 `"Dimiri"', modify
label define s1q15 14020910 `"Bun"', modify
label define s1q15 14020911 `"Sipisipi"', modify
label define s1q15 14020912 `"Girin"', modify
label define s1q15 14020913 `"Asangumut"', modify
label define s1q15 14020914 `"Mensuat"', modify
label define s1q15 14020915 `"Yambimbit"', modify
label define s1q15 14020916 `"Kambambit"', modify
label define s1q15 14020917 `"Nadvari"', modify
label define s1q15 14020918 `"Andafugun"', modify
label define s1q15 14020919 `"Yambaidog"', modify
label define s1q15 14020920 `"Olimolo"', modify
label define s1q15 14020921 `"Itipino"', modify
label define s1q15 14031001 `"Iwam"', modify
label define s1q15 14031002 `"Jikunumbu"', modify
label define s1q15 14031003 `"Kulunge"', modify
label define s1q15 14031004 `"Gongiora"', modify
label define s1q15 14031005 `"Apangai"', modify
label define s1q15 14031006 `"Ami"', modify
label define s1q15 14031007 `"Amahup"', modify
label define s1q15 14031008 `"Wamsak / Amom"', modify
label define s1q15 14031009 `"Supari"', modify
label define s1q15 14031010 `"Gwoingwon"', modify
label define s1q15 14031011 `"Dahabiga"', modify
label define s1q15 14031012 `"Kwelikum"', modify
label define s1q15 14031013 `"Walahuta"', modify
label define s1q15 14031014 `"Ningalimbi"', modify
label define s1q15 14031101 `"Albinama 1"', modify
label define s1q15 14031102 `"Timigir"', modify
label define s1q15 14031103 `"Balif 1"', modify
label define s1q15 14031104 `"Salata"', modify
label define s1q15 14031105 `"Bonohol"', modify
label define s1q15 14031106 `"Urita"', modify
label define s1q15 14031107 `"Malohum"', modify
label define s1q15 14031108 `"Kamanakor"', modify
label define s1q15 14031109 `"Sunuhu 1"', modify
label define s1q15 14031110 `"Mui 1"', modify
label define s1q15 14031111 `"Utamup"', modify
label define s1q15 14031112 `"Ilahita 1"', modify
label define s1q15 14031113 `"Ilahita 3"', modify
label define s1q15 14031114 `"Albinama 2"', modify
label define s1q15 14031115 `"Ilahita 4"', modify
label define s1q15 14031116 `"Numangu"', modify
label define s1q15 14031117 `"Taunangas"', modify
label define s1q15 14031201 `"Klabu  1"', modify
label define s1q15 14031202 `"Klabu  2"', modify
label define s1q15 14031203 `"Jame"', modify
label define s1q15 14031204 `"Niamikum"', modify
label define s1q15 14031205 `"Kuminimbis  1"', modify
label define s1q15 14031206 `"Kuminimbis  2"', modify
label define s1q15 14031207 `"Nagipaim"', modify
label define s1q15 14031208 `"Neligum"', modify
label define s1q15 14031210 `"Maprik 1"', modify
label define s1q15 14031211 `"Kinbangua"', modify
label define s1q15 14031212 `"Wora"', modify
label define s1q15 14031213 `"Gwelikum 1"', modify
label define s1q15 14031214 `"Gatnikum"', modify
label define s1q15 14031215 `"Aupik"', modify
label define s1q15 14031216 `"Lehinga"', modify
label define s1q15 14031218 `"Serakikum"', modify
label define s1q15 14031282 `"Maprik Urban"', modify
label define s1q15 14031301 `"Kombikum"', modify
label define s1q15 14031302 `"Gwarip"', modify
label define s1q15 14031303 `"Bengakum"', modify
label define s1q15 14031304 `"Yaunjange"', modify
label define s1q15 14031305 `"Suambukum"', modify
label define s1q15 14031306 `"Kwimbu 1"', modify
label define s1q15 14031307 `"Malba 1"', modify
label define s1q15 14031308 `"Ulupu"', modify
label define s1q15 14031309 `"Yalahine"', modify
label define s1q15 14031310 `"Yamil 1"', modify
label define s1q15 14031311 `"Waikakum 1"', modify
label define s1q15 14031312 `"Waikakum 3"', modify
label define s1q15 14031313 `"Saiki 1"', modify
label define s1q15 14031314 `"Dumbit"', modify
label define s1q15 14031315 `"Yenigo"', modify
label define s1q15 14031316 `"Mendiamin"', modify
label define s1q15 14041401 `"Hawain"', modify
label define s1q15 14041402 `"Niumegin"', modify
label define s1q15 14041403 `"Aring/Surumba"', modify
label define s1q15 14041404 `"Penjen/Peringa"', modify
label define s1q15 14041405 `"Siro/Wanjo"', modify
label define s1q15 14041406 `"Boikin / Dagua"', modify
label define s1q15 14041407 `"Karawap"', modify
label define s1q15 14041408 `"You island"', modify
label define s1q15 14041409 `"Karasau (Est)"', modify
label define s1q15 14041410 `"Banak/Hogi"', modify
label define s1q15 14041411 `"Bogumatai/Wautogik"', modify
label define s1q15 14041412 `"Dogur"', modify
label define s1q15 14041413 `"Woginara (1)"', modify
label define s1q15 14041414 `"Woginara (2)"', modify
label define s1q15 14041415 `"Sapuain"', modify
label define s1q15 14041416 `"Urip"', modify
label define s1q15 14041417 `"Mogopin"', modify
label define s1q15 14041418 `"Maguer"', modify
label define s1q15 14041419 `"Smain/But"', modify
label define s1q15 14041420 `"Lowan"', modify
label define s1q15 14041421 `"Kauk/Balam"', modify
label define s1q15 14041422 `"Sowom"', modify
label define s1q15 14041423 `"Kotai"', modify
label define s1q15 14041424 `"Kubren"', modify
label define s1q15 14041501 `"Mandi"', modify
label define s1q15 14041502 `"Forok"', modify
label define s1q15 14041503 `"Kep"', modify
label define s1q15 14041504 `"Suanum / Munjun"', modify
label define s1q15 14041505 `"Samap"', modify
label define s1q15 14041506 `"Ibab/Waibab"', modify
label define s1q15 14041507 `"Tring"', modify
label define s1q15 14041508 `"Yaugib"', modify
label define s1q15 14041509 `"Namarip"', modify
label define s1q15 14041510 `"Kinyare"', modify
label define s1q15 14041511 `"Kandai"', modify
label define s1q15 14041512 `"Mundagai"', modify
label define s1q15 14041513 `"Wawat"', modify
label define s1q15 14041514 `"Yamben"', modify
label define s1q15 14041515 `"Mambe"', modify
label define s1q15 14041516 `"Bungain"', modify
label define s1q15 14041517 `"Sinambali"', modify
label define s1q15 14041518 `"Manuwara"', modify
label define s1q15 14041519 `"Sir"', modify
label define s1q15 14041520 `"Putanda"', modify
label define s1q15 14041521 `"Parpur"', modify
label define s1q15 14041601 `"Biem 1"', modify
label define s1q15 14041602 `"Biem 2"', modify
label define s1q15 14041603 `"Kadowar"', modify
label define s1q15 14041604 `"Ruprup 1"', modify
label define s1q15 14041605 `"Ruprup 2"', modify
label define s1q15 14041606 `"Wei"', modify
label define s1q15 14041607 `"Koil 1"', modify
label define s1q15 14041608 `"Koil 2"', modify
label define s1q15 14041609 `"Vokeo 1"', modify
label define s1q15 14041610 `"Vokeo 2"', modify
label define s1q15 14041611 `"Koragur 1"', modify
label define s1q15 14041612 `"Koragur 2"', modify
label define s1q15 14041613 `"Shagur"', modify
label define s1q15 14041614 `"Rumalal"', modify
label define s1q15 14041615 `"Serasen"', modify
label define s1q15 14041616 `"Brauniek"', modify
label define s1q15 14041617 `"Mushu 1"', modify
label define s1q15 14041618 `"Mushu 2"', modify
label define s1q15 14041619 `"Walis 1"', modify
label define s1q15 14041620 `"Walis 2"', modify
label define s1q15 14041621 `"Tarawai"', modify
label define s1q15 14041701 `"Kambagora"', modify
label define s1q15 14041702 `"Passam 2"', modify
label define s1q15 14041703 `"Passam 1"', modify
label define s1q15 14041704 `"Paliama"', modify
label define s1q15 14041705 `"Passam 3"', modify
label define s1q15 14041706 `"Marik"', modify
label define s1q15 14041707 `"Kreer"', modify
label define s1q15 14041710 `"Magon"', modify
label define s1q15 14041712 `"Simbrangu"', modify
label define s1q15 14041713 `"Suambakau"', modify
label define s1q15 14041714 `"Hambraure"', modify
label define s1q15 14041715 `"Mangrara"', modify
label define s1q15 14041717 `"Yarapi"', modify
label define s1q15 14041719 `"Numoikim"', modify
label define s1q15 14041720 `"Urindogum"', modify
label define s1q15 14041726 `"Pangaripma"', modify
label define s1q15 14041883 `"Wewak Town"', modify
label define s1q15 14051901 `"Moi"', modify
label define s1q15 14051902 `"Banwinge/Manja"', modify
label define s1q15 14051903 `"Jama No 1"', modify
label define s1q15 14051904 `"Jama No 2"', modify
label define s1q15 14051905 `"Sengo"', modify
label define s1q15 14051906 `"Buruwi"', modify
label define s1q15 14051907 `"Maiwi"', modify
label define s1q15 14051908 `"Bensin"', modify
label define s1q15 14051909 `"Kwimba"', modify
label define s1q15 14051910 `"Kasimbi"', modify
label define s1q15 14051911 `"Aurimbit"', modify
label define s1q15 14051912 `"Wereman"', modify
label define s1q15 14051913 `"Yanget"', modify
label define s1q15 14051914 `"Wakiput"', modify
label define s1q15 14051915 `"Torembi No 1"', modify
label define s1q15 14051916 `"Torembi No 3"', modify
label define s1q15 14051917 `"Numagua 1"', modify
label define s1q15 14051918 `"Selei"', modify
label define s1q15 14051919 `"Miambe"', modify
label define s1q15 14051920 `"Worimbi"', modify
label define s1q15 14051921 `"Kembiam"', modify
label define s1q15 14051922 `"Marap 1"', modify
label define s1q15 14051923 `"Marap 2"', modify
label define s1q15 14051924 `"Nagusap"', modify
label define s1q15 14051925 `"Gaiborobi"', modify
label define s1q15 14052001 `"Sapande"', modify
label define s1q15 14052002 `"Yamanumbu"', modify
label define s1q15 14052003 `"Pagwi"', modify
label define s1q15 14052004 `"Sapanaut"', modify
label define s1q15 14052005 `"Yenjinmangua"', modify
label define s1q15 14052006 `"Nyaurange"', modify
label define s1q15 14052007 `"Kandinge"', modify
label define s1q15 14052008 `"Korogu"', modify
label define s1q15 14052009 `"Sotmeri"', modify
label define s1q15 14052010 `"Indabu"', modify
label define s1q15 14052011 `"Yenchen"', modify
label define s1q15 14052012 `"Kanganamun"', modify
label define s1q15 14052013 `"Tegowi"', modify
label define s1q15 14052014 `"Parambei"', modify
label define s1q15 14052015 `"Maringei"', modify
label define s1q15 14052016 `"Aibom"', modify
label define s1q15 14052017 `"Wombun"', modify
label define s1q15 14052018 `"Indinge"', modify
label define s1q15 14052019 `"Kirimbit"', modify
label define s1q15 14052020 `"Luluk"', modify
label define s1q15 14052021 `"Timbunmeri"', modify
label define s1q15 14052022 `"Changriman"', modify
label define s1q15 14052023 `"Mari"', modify
label define s1q15 14052024 `"Yembiyembi"', modify
label define s1q15 14052025 `"Paliagwi"', modify
label define s1q15 14052101 `"Kumunikum 1"', modify
label define s1q15 14052102 `"Kumunikum 2"', modify
label define s1q15 14052103 `"Kumunikum 3"', modify
label define s1q15 14052104 `"Tatemba"', modify
label define s1q15 14052105 `"Babandu"', modify
label define s1q15 14052106 `"Wisukum"', modify
label define s1q15 14052107 `"Numamaka"', modify
label define s1q15 14052108 `"Stapikum"', modify
label define s1q15 14052109 `"Talengi"', modify
label define s1q15 14052110 `"Kitikum"', modify
label define s1q15 14052111 `"Numbingei"', modify
label define s1q15 14052113 `"Gualakum"', modify
label define s1q15 14052114 `"Kwatmukum"', modify
label define s1q15 14052115 `"Sarikum"', modify
label define s1q15 14052116 `"Bukibalikum"', modify
label define s1q15 14052117 `"Jambitangit"', modify
label define s1q15 14052118 `"Wapindumaka"', modify
label define s1q15 14052119 `"Jipako"', modify
label define s1q15 14052120 `"Manjikoruwi"', modify
label define s1q15 14052121 `"Umunko"', modify
label define s1q15 14052123 `"Jipakim"', modify
label define s1q15 14052124 `"Ugutakua"', modify
label define s1q15 14052125 `"Weiko"', modify
label define s1q15 14052126 `"Dumek"', modify
label define s1q15 14052127 `"Nungwaia"', modify
label define s1q15 14052128 `"Kwanga"', modify
label define s1q15 14052201 `"Jikinangu"', modify
label define s1q15 14052202 `"Tiendikum"', modify
label define s1q15 14052203 `"Miko 1"', modify
label define s1q15 14052204 `"Konambandu"', modify
label define s1q15 14052205 `"Konambandu 3"', modify
label define s1q15 14052206 `"Tukwokum"', modify
label define s1q15 14052207 `"Apusit"', modify
label define s1q15 14052208 `"Nala"', modify
label define s1q15 14052209 `"Kunjingini"', modify
label define s1q15 14052210 `"Mul"', modify
label define s1q15 14052211 `"Waikamoko"', modify
label define s1q15 14052212 `"Rubukum"', modify
label define s1q15 14052213 `"Gwaiwaru"', modify
label define s1q15 14052214 `"Moundu"', modify
label define s1q15 14052215 `"Kamge"', modify
label define s1q15 14052216 `"Patigo"', modify
label define s1q15 14052217 `"Serangwandu"', modify
label define s1q15 14052218 `"Palgerr"', modify
label define s1q15 14052219 `"Nangda"', modify
label define s1q15 14052220 `"Mikau"', modify
label define s1q15 14052221 `"Wambisa"', modify
label define s1q15 14052222 `"Kuanjoma"', modify
label define s1q15 14052223 `"Pukago"', modify
label define s1q15 14052224 `"Jipmako"', modify
label define s1q15 14052225 `"Nungwaiko"', modify
label define s1q15 14052226 `"Kwalget"', modify
label define s1q15 14052227 `"Apambi"', modify
label define s1q15 14052228 `"Gupmapil"', modify
label define s1q15 14062301 `"Pachen/Karapia"', modify
label define s1q15 14062302 `"Yangoru Station"', modify
label define s1q15 14062303 `"Numboguon"', modify
label define s1q15 14062304 `"Baimuru"', modify
label define s1q15 14062305 `"Bukienduon"', modify
label define s1q15 14062306 `"Marambanja"', modify
label define s1q15 14062307 `"Sima"', modify
label define s1q15 14062308 `"Howi/Wamaina"', modify
label define s1q15 14062309 `"Kufar/Ambokon"', modify
label define s1q15 14062310 `"Siniangu/Mombuk"', modify
label define s1q15 14062311 `"Witupe1"', modify
label define s1q15 14062312 `"Koro"', modify
label define s1q15 14062313 `"Makambu"', modify
label define s1q15 14062314 `"Kiniambu"', modify
label define s1q15 14062315 `"Haripmo 1,2&amp;3"', modify
label define s1q15 14062316 `"Merohombi"', modify
label define s1q15 14062317 `"Kwagwie"', modify
label define s1q15 14062318 `"Hagama"', modify
label define s1q15 14062319 `"Soli"', modify
label define s1q15 14062320 `"Parina"', modify
label define s1q15 14062321 `"Ambukanja"', modify
label define s1q15 14062322 `"Kiarivu"', modify
label define s1q15 14062323 `"Kworabri"', modify
label define s1q15 14062324 `"Simbomie/Sengri"', modify
label define s1q15 14062325 `"Yekimbolye 2"', modify
label define s1q15 14062326 `"Kamanja"', modify
label define s1q15 14062327 `"Witupe 2"', modify
label define s1q15 14062401 `"Kininien"', modify
label define s1q15 14062402 `"Harua"', modify
label define s1q15 14062403 `"Wamaian"', modify
label define s1q15 14062404 `"Sasenumbohu"', modify
label define s1q15 14062405 `"Niakandogum"', modify
label define s1q15 14062406 `"Neimo"', modify
label define s1q15 14062407 `"Niagombi"', modify
label define s1q15 14062408 `"Mushuagen"', modify
label define s1q15 14062409 `"Waremba"', modify
label define s1q15 14062410 `"Nimbogu"', modify
label define s1q15 14062411 `"Abawia"', modify
label define s1q15 14062412 `"Hambuke"', modify
label define s1q15 14062413 `"Hanyak"', modify
label define s1q15 14062414 `"Numindogum"', modify
label define s1q15 14062415 `"Nangumaren"', modify
label define s1q15 14062416 `"Tangori 1"', modify
label define s1q15 14062417 `"Sasoya"', modify
label define s1q15 14062418 `"Tangori 2"', modify
label define s1q15 14062419 `"Papieng"', modify
label define s1q15 14062420 `"Huaripmogum"', modify
label define s1q15 14062421 `"Nungori"', modify
label define s1q15 14062422 `"Para"', modify
label define s1q15 14062423 `"Paparom"', modify
label define s1q15 14062501 `"Urigembi"', modify
label define s1q15 14062502 `"Japaraka"', modify
label define s1q15 14062503 `"Yari/Nungawa"', modify
label define s1q15 14062504 `"Wiomungu"', modify
label define s1q15 14062505 `"Tuonumbu"', modify
label define s1q15 14062506 `"Munji"', modify
label define s1q15 14062507 `"Suadogum"', modify
label define s1q15 14062508 `"Rofundogum"', modify
label define s1q15 14062509 `"Bima"', modify
label define s1q15 14062510 `"Timunangua"', modify
label define s1q15 14062511 `"Werman"', modify
label define s1q15 14062512 `"Bararat"', modify
label define s1q15 14062513 `"Peringa"', modify
label define s1q15 14062514 `"Wambe"', modify
label define s1q15 14062515 `"Rabiawa"', modify
label define s1q15 14062516 `"Kambaraka"', modify
label define s1q15 14062517 `"Wamagu"', modify
label define s1q15 14062518 `"Japaraka 1"', modify
label define s1q15 14062519 `"Porombe"', modify
label define s1q15 14062520 `"Segero"', modify
label define s1q15 14062521 `"Kusaun"', modify
label define s1q15 14062601 `"Kumun"', modify
label define s1q15 14062602 `"Kumbuhun"', modify
label define s1q15 14062603 `"Wihun (Boinam)"', modify
label define s1q15 14062604 `"Himbruolye/Buki"', modify
label define s1q15 14062605 `"Alisu"', modify
label define s1q15 14062606 `"Bonahitam"', modify
label define s1q15 14062607 `"Koboibus"', modify
label define s1q15 14062608 `"Yabamunu"', modify
label define s1q15 14062609 `"Kuragumun"', modify
label define s1q15 14062610 `"Bukitu"', modify
label define s1q15 14062611 `"Wingei 1"', modify
label define s1q15 14062612 `"Wingei 2"', modify
label define s1q15 14062613 `"Bepandu"', modify
label define s1q15 14062614 `"Yekingen &amp; Belmo"', modify
label define s1q15 14062615 `"Sara"', modify
label define s1q15 14062616 `"Holik"', modify
label define s1q15 14062617 `"Nindibolye"', modify
label define s1q15 14062618 `"Kwaian"', modify
label define s1q15 14062619 `"Duningi"', modify
label define s1q15 14062620 `"Miambauru"', modify
label define s1q15 14062621 `"Nambari"', modify
label define s1q15 14062622 `"Malapaem"', modify
label define s1q15 14062623 `"Ilipaem"', modify
label define s1q15 14062624 `"Guningi"', modify
label define s1q15 14062625 `"Nimbihu"', modify
label define s1q15 15010103 `"Poltulul"', modify
label define s1q15 15010104 `"Tales-Iambu"', modify
label define s1q15 15010105 `"Tumeleo Island"', modify
label define s1q15 15010106 `"Ali Island"', modify
label define s1q15 15010107 `"Seleo Island"', modify
label define s1q15 15010108 `"Poro Settlement"', modify
label define s1q15 15010109 `"Lupai"', modify
label define s1q15 15010110 `"Wauningi"', modify
label define s1q15 15010111 `"Pes"', modify
label define s1q15 15010112 `"Prou/Vokau"', modify
label define s1q15 15010113 `"Lemieng"', modify
label define s1q15 15010114 `"Chinapeli"', modify
label define s1q15 15010115 `"Kiriel-Kopom"', modify
label define s1q15 15010116 `"Paup"', modify
label define s1q15 15010117 `"Yakamul 1"', modify
label define s1q15 15010118 `"Yakamul 2"', modify
label define s1q15 15010119 `"Ulau 1"', modify
label define s1q15 15010120 `"Ulau 2"', modify
label define s1q15 15010121 `"Suain"', modify
label define s1q15 15010122 `"Labuain"', modify
label define s1q15 15010123 `"Wamsis"', modify
label define s1q15 15010124 `"Balup"', modify
label define s1q15 15010125 `"Matapau"', modify
label define s1q15 15010180 `"Aitape Urban"', modify
label define s1q15 15010201 `"Kamnom"', modify
label define s1q15 15010202 `"Bulwo"', modify
label define s1q15 15010203 `"Yiklau"', modify
label define s1q15 15010204 `"Maurom"', modify
label define s1q15 15010205 `"Kulnom"', modify
label define s1q15 15010206 `"Kweftim"', modify
label define s1q15 15010207 `"Eritei 2"', modify
label define s1q15 15010208 `"Taute"', modify
label define s1q15 15010209 `"Maui/Talbibi"', modify
label define s1q15 15010210 `"Lumi"', modify
label define s1q15 15010211 `"Oute"', modify
label define s1q15 15010212 `"Tabale"', modify
label define s1q15 15010213 `"Karate"', modify
label define s1q15 15010214 `"Sainde"', modify
label define s1q15 15010215 `"Mabul"', modify
label define s1q15 15010301 `"Nimas"', modify
label define s1q15 15010302 `"Manyer (Sissano)"', modify
label define s1q15 15010303 `"Maindroin (Sissano)"', modify
label define s1q15 15010304 `"Paupa"', modify
label define s1q15 15010306 `"Arop 1"', modify
label define s1q15 15010307 `"Arop 2"', modify
label define s1q15 15010308 `"Mainyen"', modify
label define s1q15 15010309 `"Tanyapin"', modify
label define s1q15 15010310 `"Aipokon"', modify
label define s1q15 15010311 `"Nengian"', modify
label define s1q15 15010312 `"Koiniri"', modify
label define s1q15 15010313 `"Walwale"', modify
label define s1q15 15010314 `"Rome"', modify
label define s1q15 15010315 `"Barera"', modify
label define s1q15 15010316 `"Kaiye"', modify
label define s1q15 15010317 `"Mafoka"', modify
label define s1q15 15010318 `"Mori"', modify
label define s1q15 15010319 `"Mumuru"', modify
label define s1q15 15010320 `"Sumo"', modify
label define s1q15 15010321 `"Ramo"', modify
label define s1q15 15010322 `"Pou"', modify
label define s1q15 15010323 `"Sarai"', modify
label define s1q15 15010324 `"Rainuk"', modify
label define s1q15 15010325 `"Amsuku"', modify
label define s1q15 15010401 `"Kabore"', modify
label define s1q15 15010402 `"Molmo"', modify
label define s1q15 15010403 `"Pelama"', modify
label define s1q15 15010404 `"Kakoi"', modify
label define s1q15 15010405 `"Yebil"', modify
label define s1q15 15010406 `"Inebu"', modify
label define s1q15 15010407 `"Mokai"', modify
label define s1q15 15010408 `"Karaitem"', modify
label define s1q15 15010409 `"Minate"', modify
label define s1q15 15010410 `"Sibote"', modify
label define s1q15 15010411 `"Miwaute"', modify
label define s1q15 15010412 `"Wabute"', modify
label define s1q15 15010413 `"Kupuom"', modify
label define s1q15 15010414 `"Wigote"', modify
label define s1q15 15010415 `"Kumnate"', modify
label define s1q15 15020501 `"Seleput"', modify
label define s1q15 15020502 `"Nuku"', modify
label define s1q15 15020503 `"Mantsuku"', modify
label define s1q15 15020504 `"Yiminum"', modify
label define s1q15 15020505 `"ifkindu"', modify
label define s1q15 15020506 `"Wilwil"', modify
label define s1q15 15020507 `"Kaflei"', modify
label define s1q15 15020508 `"Kaflei 3"', modify
label define s1q15 15020509 `"Arkosame 1"', modify
label define s1q15 15020510 `"Arkosame 2"', modify
label define s1q15 15020511 `"Hambasama"', modify
label define s1q15 15020512 `"Angara"', modify
label define s1q15 15020513 `"Abigu"', modify
label define s1q15 15020514 `"Usitamu"', modify
label define s1q15 15020515 `"Hambanori"', modify
label define s1q15 15020516 `"Engiep"', modify
label define s1q15 15020517 `"Wombiu"', modify
label define s1q15 15020521 `"Wulbowe"', modify
label define s1q15 15020522 `"Tukinaro"', modify
label define s1q15 15020530 `"Yirwondi"', modify
label define s1q15 15020531 `"Sepitala"', modify
label define s1q15 15020601 `"Kuvalvu"', modify
label define s1q15 15020602 `"Monandin"', modify
label define s1q15 15020603 `"Nangen"', modify
label define s1q15 15020604 `"Yadagaro"', modify
label define s1q15 15020605 `"Sundun"', modify
label define s1q15 15020606 `"Kolembi"', modify
label define s1q15 15020607 `"Sumambum"', modify
label define s1q15 15020608 `"Asier"', modify
label define s1q15 15020609 `"Binare"', modify
label define s1q15 15020610 `"Boini"', modify
label define s1q15 15020611 `"Wara"', modify
label define s1q15 15020612 `"Muku"', modify
label define s1q15 15020613 `"Yeresi"', modify
label define s1q15 15020614 `"Sabig"', modify
label define s1q15 15020615 `"Mai"', modify
label define s1q15 15020619 `"Yambil"', modify
label define s1q15 15020620 `"Sengi"', modify
label define s1q15 15020621 `"Yolpa"', modify
label define s1q15 15020622 `"Munumbal"', modify
label define s1q15 15020701 `"Ausin/Yumoun"', modify
label define s1q15 15020702 `"Mupun/Sikel"', modify
label define s1q15 15020703 `"Weikint/Nunsi"', modify
label define s1q15 15020704 `"Yuwil/Yemlu"', modify
label define s1q15 15020705 `"Laingim/Soloku"', modify
label define s1q15 15020706 `"Wulukum"', modify
label define s1q15 15020707 `"Piom/Lalwi"', modify
label define s1q15 15020708 `"Bimon/Maibel"', modify
label define s1q15 15020709 `"Yili/Tomoum"', modify
label define s1q15 15020710 `"Pinkil/Bairap"', modify
label define s1q15 15020711 `"Warin/Witaili"', modify
label define s1q15 15020712 `"Puang/Witikin"', modify
label define s1q15 15020713 `"Weis/Witwan"', modify
label define s1q15 15020714 `"Tomontonik/Yemnu"', modify
label define s1q15 15020715 `"Anguganak"', modify
label define s1q15 15020716 `"Rawot"', modify
label define s1q15 15020717 `"Maimbel"', modify
label define s1q15 15020718 `"Brugap/Bogasip"', modify
label define s1q15 15020719 `"Yangkok"', modify
label define s1q15 15020721 `"Mushu/Wublakil"', modify
label define s1q15 15021701 `"Yimin"', modify
label define s1q15 15021702 `"Nau'alu"', modify
label define s1q15 15021703 `"Gamu/Ulap"', modify
label define s1q15 15021704 `"Yimut"', modify
label define s1q15 15021705 `"Wundu"', modify
label define s1q15 15021706 `"Yimauwi"', modify
label define s1q15 15021707 `"Yauwo"', modify
label define s1q15 15021708 `"Maimai"', modify
label define s1q15 15021709 `"Aimukuli"', modify
label define s1q15 15021710 `"Mukili"', modify
label define s1q15 15021711 `"Yulem"', modify
label define s1q15 15021712 `"Yemeraba"', modify
label define s1q15 15021713 `"Wemil"', modify
label define s1q15 15021714 `"Leiko"', modify
label define s1q15 15021715 `"Waniwomoko"', modify
label define s1q15 15030801 `"Abrau"', modify
label define s1q15 15030802 `"Alendami"', modify
label define s1q15 15030803 `"Akwom"', modify
label define s1q15 15030804 `"Augom"', modify
label define s1q15 15030805 `"Alai"', modify
label define s1q15 15030806 `"Ameni"', modify
label define s1q15 15030807 `"Iwani"', modify
label define s1q15 15030808 `"Magleri"', modify
label define s1q15 15030809 `"Mantopai"', modify
label define s1q15 15030810 `"Warukori"', modify
label define s1q15 15030811 `"Norambalip"', modify
label define s1q15 15030812 `"Yakaltim"', modify
label define s1q15 15030813 `"Yegarapi"', modify
label define s1q15 15030814 `"Yilui"', modify
label define s1q15 15030815 `"Edwaki"', modify
label define s1q15 15030901 `"Ranimap"', modify
label define s1q15 15030902 `"Betianap"', modify
label define s1q15 15030903 `"Divanap"', modify
label define s1q15 15030904 `"Kuiva"', modify
label define s1q15 15030905 `"Kusanap"', modify
label define s1q15 15030906 `"Mitaganap"', modify
label define s1q15 15030907 `"Tekap"', modify
label define s1q15 15030908 `"Teranap"', modify
label define s1q15 15030909 `"Tomianap"', modify
label define s1q15 15030910 `"Seremty"', modify
label define s1q15 15030911 `"Oksapmin Sub District"', modify
label define s1q15 15030912 `"Bimin"', modify
label define s1q15 15030913 `"Daburap"', modify
label define s1q15 15030914 `"Duban"', modify
label define s1q15 15030915 `"Kweptanap"', modify
label define s1q15 15030916 `"Sungtem"', modify
label define s1q15 15030917 `"Umanap"', modify
label define s1q15 15030918 `"Akiapmin"', modify
label define s1q15 15030919 `"Lembana"', modify
label define s1q15 15030920 `"Monduban"', modify
label define s1q15 15030921 `"Tomware"', modify
label define s1q15 15031001 `"Amaromin"', modify
label define s1q15 15031002 `"Fuiaimin"', modify
label define s1q15 15031003 `"Bovripmin"', modify
label define s1q15 15031004 `"Sogamin"', modify
label define s1q15 15031005 `"Temsapmin"', modify
label define s1q15 15031006 `"Abungkamin"', modify
label define s1q15 15031007 `"Afogavip"', modify
label define s1q15 15031008 `"Agamtauip"', modify
label define s1q15 15031009 `"Anavip-Kalikman"', modify
label define s1q15 15031010 `"Atemtkiakmin"', modify
label define s1q15 15031011 `"Bofulmin/Tifalmin"', modify
label define s1q15 15031012 `"Bogalmin"', modify
label define s1q15 15031013 `"Drolengam"', modify
label define s1q15 15031014 `"Famukin"', modify
label define s1q15 15031015 `"Inantigin"', modify
label define s1q15 15031016 `"Kialikman/Framen"', modify
label define s1q15 15031017 `"Urapmin"', modify
label define s1q15 15031018 `"Kobrenmin"', modify
label define s1q15 15031019 `"Kobrenmin/Framin"', modify
label define s1q15 15031020 `"Komdavip"', modify
label define s1q15 15031021 `"Ofektaman"', modify
label define s1q15 15031022 `"Okbilavip"', modify
label define s1q15 15031023 `"Siliambil"', modify
label define s1q15 15031024 `"Fumenavip"', modify
label define s1q15 15031025 `"Wabia"', modify
label define s1q15 15031026 `"Freda Base"', modify
label define s1q15 15031101 `"Imnai 1"', modify
label define s1q15 15031102 `"Imnai 2"', modify
label define s1q15 15031103 `"Bitapena"', modify
label define s1q15 15031104 `"Tumolbil"', modify
label define s1q15 15031105 `"Ivikmin"', modify
label define s1q15 15031106 `"Kemeimin"', modify
label define s1q15 15031108 `"Sokonga"', modify
label define s1q15 15031109 `"Bakading"', modify
label define s1q15 15031110 `"Fungal"', modify
label define s1q15 15031111 `"Bilka"', modify
label define s1q15 15031113 `"Wauru"', modify
label define s1q15 15031114 `"Defakbil"', modify
label define s1q15 15031115 `"Mututeimin"', modify
label define s1q15 15031116 `"Umfokmin"', modify
label define s1q15 15031117 `"Atensikin"', modify
label define s1q15 15031118 `"Mongapbip"', modify
label define s1q15 15031119 `"Fiamok"', modify
label define s1q15 15031120 `"Busulmin"', modify
label define s1q15 15041201 `"Bibriari"', modify
label define s1q15 15041202 `"Porumun"', modify
label define s1q15 15041203 `"Itomi"', modify
label define s1q15 15041204 `"Mamamura"', modify
label define s1q15 15041205 `"Wahai"', modify
label define s1q15 15041206 `"Kamberatoro"', modify
label define s1q15 15041207 `"Kofiniau"', modify
label define s1q15 15041208 `"Iafar"', modify
label define s1q15 15041209 `"Naineri"', modify
label define s1q15 15041210 `"Wamuru"', modify
label define s1q15 15041211 `"Aheri"', modify
label define s1q15 15041212 `"Amanab Station"', modify
label define s1q15 15041213 `"Iveig"', modify
label define s1q15 15041214 `"Akraminag"', modify
label define s1q15 15041215 `"Masineri-Nai No.2"', modify
label define s1q15 15041216 `"Utai"', modify
label define s1q15 15041217 `"Guriaso"', modify
label define s1q15 15041218 `"Komtari"', modify
label define s1q15 15041301 `"Wutung"', modify
label define s1q15 15041302 `"Musu"', modify
label define s1q15 15041303 `"Yaukono"', modify
label define s1q15 15041304 `"Yako"', modify
label define s1q15 15041305 `"Warimo"', modify
label define s1q15 15041306 `"Vanimo (Lido)"', modify
label define s1q15 15041307 `"Ningra"', modify
label define s1q15 15041308 `"Rawo"', modify
label define s1q15 15041309 `"Poko"', modify
label define s1q15 15041310 `"Nowake"', modify
label define s1q15 15041311 `"Laitre"', modify
label define s1q15 15041312 `"Puari"', modify
label define s1q15 15041313 `"Onei"', modify
label define s1q15 15041314 `"Osol"', modify
label define s1q15 15041315 `"Krisa"', modify
label define s1q15 15041316 `"Ossima"', modify
label define s1q15 15041317 `"Kilipau"', modify
label define s1q15 15041318 `"Ilup"', modify
label define s1q15 15041319 `"Amoi"', modify
label define s1q15 15041320 `"Somboi"', modify
label define s1q15 15041321 `"Ituly"', modify
label define s1q15 15041322 `"Skotiaho"', modify
label define s1q15 15041323 `"Ainbai"', modify
label define s1q15 15041324 `"Sumumini"', modify
label define s1q15 15041325 `"Imbio 2"', modify
label define s1q15 15041326 `"Imbrinis"', modify
label define s1q15 15041401 `"Abaru"', modify
label define s1q15 15041402 `"Dieru"', modify
label define s1q15 15041403 `"Hogru"', modify
label define s1q15 15041404 `"Rawei"', modify
label define s1q15 15041405 `"Nagatiman"', modify
label define s1q15 15041406 `"Dila"', modify
label define s1q15 15041407 `"Marakwini"', modify
label define s1q15 15041408 `"Wagu"', modify
label define s1q15 15041409 `"Beimap"', modify
label define s1q15 15041410 `"Seiawi"', modify
label define s1q15 15041411 `"Amto"', modify
label define s1q15 15041412 `"Bisiabru"', modify
label define s1q15 15041413 `"Idam 1"', modify
label define s1q15 15041414 `"Idam 2"', modify
label define s1q15 15041415 `"Hufi"', modify
label define s1q15 15041416 `"Biake 1"', modify
label define s1q15 15041417 `"Kaiseiru"', modify
label define s1q15 15041418 `"Sokmaiyon"', modify
label define s1q15 15041419 `"Kobraru"', modify
label define s1q15 15041420 `"Yabru"', modify
label define s1q15 15041421 `"Buna"', modify
label define s1q15 15041422 `"Mahanei"', modify
label define s1q15 15041423 `"Mukuasi"', modify
label define s1q15 15041424 `"Bifro"', modify
label define s1q15 15041425 `"Baio"', modify
label define s1q15 15041426 `"Yibru"', modify
label define s1q15 15041427 `"Miniabru"', modify
label define s1q15 15041428 `"Auiya 1"', modify
label define s1q15 15041429 `"Kambriap"', modify
label define s1q15 15041430 `"Fonginum"', modify
label define s1q15 15041431 `"Iuri 1"', modify
label define s1q15 15041432 `"Tingirapu"', modify
label define s1q15 15041433 `"Amini"', modify
label define s1q15 15041434 `"Samunai"', modify
label define s1q15 15041435 `"Miarfai"', modify
label define s1q15 15041436 `"Biaka"', modify
label define s1q15 15041581 `"Vanimo Town"', modify
label define s1q15 15041601 `"Doandai"', modify
label define s1q15 15041602 `"Smock"', modify
label define s1q15 15041603 `"Namola"', modify
label define s1q15 15041604 `"Daunchendi"', modify
label define s1q15 15041605 `"Epmi"', modify
label define s1q15 15041606 `"Doponendi"', modify
label define s1q15 15041607 `"Wainda"', modify
label define s1q15 15041608 `"Holosa"', modify
label define s1q15 15041609 `"Daundi"', modify
label define s1q15 15041610 `"Tamina 1"', modify
label define s1q15 15041611 `"Fas 1"', modify
label define s1q15 15041612 `"Waina"', modify
label define s1q15 15041613 `"Punda"', modify
label define s1q15 16010101 `"Auna 1"', modify
label define s1q15 16010102 `"Onnei 1"', modify
label define s1q15 16010103 `"Aua Island 1"', modify
label define s1q15 16010104 `"Aua 2"', modify
label define s1q15 16010105 `"Onnei 2"', modify
label define s1q15 16010106 `"Auna 2"', modify
label define s1q15 16010201 `"Pateku"', modify
label define s1q15 16010202 `"Lau Island"', modify
label define s1q15 16010203 `"Pihon"', modify
label define s1q15 16010204 `"Liot"', modify
label define s1q15 16010205 `"Luf"', modify
label define s1q15 16010206 `"Amik"', modify
label define s1q15 16010301 `"Salien"', modify
label define s1q15 16010302 `"Nihon"', modify
label define s1q15 16010303 `"Kali"', modify
label define s1q15 16010304 `"Maso"', modify
label define s1q15 16010305 `"Matahai"', modify
label define s1q15 16010306 `"Salapai"', modify
label define s1q15 16010307 `"Lessau"', modify
label define s1q15 16010308 `"Harengau"', modify
label define s1q15 16010309 `"Jowan 1"', modify
label define s1q15 16010310 `"Jowan 2"', modify
label define s1q15 16010311 `"Nyada"', modify
label define s1q15 16010312 `"Levei"', modify
label define s1q15 16010313 `"Sori 2"', modify
label define s1q15 16010314 `"Sori 1"', modify
label define s1q15 16010401 `"Ponam"', modify
label define s1q15 16010402 `"Tulu 1"', modify
label define s1q15 16010403 `"Tulu 2"', modify
label define s1q15 16010404 `"Lahapau"', modify
label define s1q15 16010405 `"Bundralis C/Mssn"', modify
label define s1q15 16010406 `"Lehewa"', modify
label define s1q15 16010407 `"Saha"', modify
label define s1q15 16010408 `"N'drehet"', modify
label define s1q15 16010409 `"Liap"', modify
label define s1q15 16010410 `"Derimbat"', modify
label define s1q15 16010411 `"Andra Island"', modify
label define s1q15 16010412 `"Souh"', modify
label define s1q15 16010413 `"Mundrau"', modify
label define s1q15 16010414 `"Patlok"', modify
label define s1q15 16010415 `"Mundripureu"', modify
label define s1q15 16010416 `"Pundru"', modify
label define s1q15 16010417 `"Wamandra"', modify
label define s1q15 16010501 `"Malapang"', modify
label define s1q15 16010502 `"Horan"', modify
label define s1q15 16010503 `"Powat"', modify
label define s1q15 16010504 `"Maraman"', modify
label define s1q15 16010505 `"Lapahan"', modify
label define s1q15 16010506 `"N'Drakot"', modify
label define s1q15 16010507 `"Lowa"', modify
label define s1q15 16010508 `"Ahus"', modify
label define s1q15 16010509 `"Yiringou"', modify
label define s1q15 16010510 `"Bowat 1"', modify
label define s1q15 16010511 `"Lundret"', modify
label define s1q15 16010512 `"Rossum"', modify
label define s1q15 16010513 `"Dungoumasih"', modify
label define s1q15 16010514 `"Sapon 1"', modify
label define s1q15 16010515 `"Warambei"', modify
label define s1q15 16010516 `"Pityluh"', modify
label define s1q15 16010517 `"N'drilou"', modify
label define s1q15 16010680 `"Lorengau Urban"', modify
label define s1q15 16010701 `"Loniu"', modify
label define s1q15 16010702 `"Lolak"', modify
label define s1q15 16010703 `"Lombrum"', modify
label define s1q15 16010704 `"Papitalai"', modify
label define s1q15 16010705 `"Naringel"', modify
label define s1q15 16010706 `"Riuriu"', modify
label define s1q15 16010707 `"Salamei Settlement"', modify
label define s1q15 16010708 `"Mokareng"', modify
label define s1q15 16010781 `"Lombrum Naval Base"', modify
label define s1q15 16010801 `"N'drapitou"', modify
label define s1q15 16010802 `"Soheneriu"', modify
label define s1q15 16010803 `"Kapou"', modify
label define s1q15 16010804 `"Bulihan"', modify
label define s1q15 16010805 `"Karun"', modify
label define s1q15 16010806 `"Sirrah"', modify
label define s1q15 16010807 `"Lawes"', modify
label define s1q15 16010808 `"Nohang"', modify
label define s1q15 16010809 `"Katin"', modify
label define s1q15 16010810 `"Lowaiya"', modify
label define s1q15 16010811 `"Lapap Lahan"', modify
label define s1q15 16010812 `"Maleh"', modify
label define s1q15 16010813 `"M'bunai"', modify
label define s1q15 16010814 `"Pere 1"', modify
label define s1q15 16010818 `"Patusi"', modify
label define s1q15 16010901 `"Buyang"', modify
label define s1q15 16010902 `"Kawaliap"', modify
label define s1q15 16010903 `"Tingou"', modify
label define s1q15 16010904 `"Londru"', modify
label define s1q15 16010905 `"Pitariat"', modify
label define s1q15 16010906 `"Tawi"', modify
label define s1q15 16011001 `"M'buke/Whal"', modify
label define s1q15 16011002 `"Bundrahei/Sabondralis"', modify
label define s1q15 16011003 `"Likum"', modify
label define s1q15 16011004 `"Babun"', modify
label define s1q15 16011005 `"Butjou"', modify
label define s1q15 16011006 `"Timoenai"', modify
label define s1q15 16011007 `"Pohowadeyaha"', modify
label define s1q15 16011008 `"Jekal"', modify
label define s1q15 16011009 `"Peli Patu"', modify
label define s1q15 16011101 `"Mouk"', modify
label define s1q15 16011102 `"Lipan"', modify
label define s1q15 16011103 `"Sone"', modify
label define s1q15 16011104 `"Parioi"', modify
label define s1q15 16011105 `"Buiat"', modify
label define s1q15 16011106 `"Baon"', modify
label define s1q15 16011107 `"Solang"', modify
label define s1q15 16011108 `"Rei"', modify
label define s1q15 16011109 `"Lako"', modify
label define s1q15 16011201 `"Mokarah"', modify
label define s1q15 16011202 `"Hahai"', modify
label define s1q15 16011203 `"Tong"', modify
label define s1q15 16011204 `"Nauna"', modify
label define s1q15 16011205 `"Polobuli"', modify
label define s1q15 16011206 `"Kuluo"', modify
label define s1q15 16011207 `"Penchal"', modify
label define s1q15 16011208 `"Lenkau"', modify
label define s1q15 16011209 `"Mouklen"', modify
label define s1q15 17010101 `"Tasitel"', modify
label define s1q15 17010102 `"Magien"', modify
label define s1q15 17010103 `"Loliang"', modify
label define s1q15 17010104 `"Palakau"', modify
label define s1q15 17010105 `"Emira"', modify
label define s1q15 17010106 `"Tench"', modify
label define s1q15 17010201 `"Taskul"', modify
label define s1q15 17010202 `"Patiagaga"', modify
label define s1q15 17010203 `"Patipai"', modify
label define s1q15 17010204 `"Ungakum"', modify
label define s1q15 17010205 `"Tsoi"', modify
label define s1q15 17010206 `"Tukulisava"', modify
label define s1q15 17010207 `"Ungalik"', modify
label define s1q15 17010208 `"Meterankasing"', modify
label define s1q15 17010209 `"Noipuas"', modify
label define s1q15 17010210 `"Sosson"', modify
label define s1q15 17010211 `"Tingwon"', modify
label define s1q15 17010212 `"Umbukul"', modify
label define s1q15 17010213 `"Kone"', modify
label define s1q15 17010214 `"Meteselen"', modify
label define s1q15 17010215 `"Tioputuk"', modify
label define s1q15 17010216 `"Lovongai"', modify
label define s1q15 17010217 `"Meterangkang"', modify
label define s1q15 17010218 `"Lungatang"', modify
label define s1q15 17010219 `"Kulingei"', modify
label define s1q15 17010301 `"Enang"', modify
label define s1q15 17010302 `"Nonovaul"', modify
label define s1q15 17010303 `"Panapai"', modify
label define s1q15 17010304 `"Kaselok"', modify
label define s1q15 17010305 `"Bagatare"', modify
label define s1q15 17010306 `"Lokono"', modify
label define s1q15 17010307 `"Ngavalus"', modify
label define s1q15 17010308 `"Paruai"', modify
label define s1q15 17010309 `"Lemakot"', modify
label define s1q15 17010310 `"Panamana"', modify
label define s1q15 17010311 `"Madina"', modify
label define s1q15 17010312 `"Kafkaf"', modify
label define s1q15 17010313 `"Namasalang"', modify
label define s1q15 17010314 `"Belifu"', modify
label define s1q15 17010315 `"Pangeifua"', modify
label define s1q15 17010316 `"Lamusmus"', modify
label define s1q15 17010317 `"Leon"', modify
label define s1q15 17010318 `"Lapai"', modify
label define s1q15 17010383 `"Lakurumau Estate"', modify
label define s1q15 17010404 `"Bagail"', modify
label define s1q15 17010405 `"Kulangit"', modify
label define s1q15 17010406 `"Maiom"', modify
label define s1q15 17010480 `"Kavieng Urban"', modify
label define s1q15 17020501 `"Palabong"', modify
label define s1q15 17020502 `"Kabanut"', modify
label define s1q15 17020503 `"Matakan"', modify
label define s1q15 17020504 `"Burau"', modify
label define s1q15 17020505 `"Rasirik"', modify
label define s1q15 17020506 `"Labur"', modify
label define s1q15 17020507 `"Loloba"', modify
label define s1q15 17020508 `"Kanapit"', modify
label define s1q15 17020509 `"Pire"', modify
label define s1q15 17020510 `"Namatanai"', modify
label define s1q15 17020512 `"Salimun"', modify
label define s1q15 17020513 `"Bisapu"', modify
label define s1q15 17020514 `"Sopau"', modify
label define s1q15 17020515 `"Rativis"', modify
label define s1q15 17020516 `"Hipaling"', modify
label define s1q15 17020517 `"Himau"', modify
label define s1q15 17020518 `"Nokon"', modify
label define s1q15 17020519 `"Hipakat"', modify
label define s1q15 17020520 `"Kembeng"', modify
label define s1q15 17020521 `"Sena"', modify
label define s1q15 17020581 `"Namatanai Urban"', modify
label define s1q15 17020601 `"Simberi"', modify
label define s1q15 17020602 `"Tatau"', modify
label define s1q15 17020603 `"Datava"', modify
label define s1q15 17020604 `"Mapua"', modify
label define s1q15 17020605 `"Wang"', modify
label define s1q15 17020606 `"Tandis"', modify
label define s1q15 17020607 `"Lossu"', modify
label define s1q15 17020608 `"Konos"', modify
label define s1q15 17020609 `"Kimadan"', modify
label define s1q15 17020610 `"Lelet"', modify
label define s1q15 17020611 `"Dalom"', modify
label define s1q15 17020612 `"Lemeris"', modify
label define s1q15 17020613 `"Bulu"', modify
label define s1q15 17020614 `"Karu"', modify
label define s1q15 17020615 `"Komalu"', modify
label define s1q15 17020616 `"Komalapuo"', modify
label define s1q15 17020617 `"Daun"', modify
label define s1q15 17020618 `"Messi"', modify
label define s1q15 17020619 `"Ugana"', modify
label define s1q15 17020620 `"Lamau"', modify
label define s1q15 17020621 `"Patlanga"', modify
label define s1q15 17020622 `"Panaras"', modify
label define s1q15 17020701 `"Weilo"', modify
label define s1q15 17020702 `"Rei"', modify
label define s1q15 17020703 `"Kamiang"', modify
label define s1q15 17020704 `"Morkon"', modify
label define s1q15 17020705 `"Kamilai"', modify
label define s1q15 17020706 `"Bakum"', modify
label define s1q15 17020707 `"Pukunmal"', modify
label define s1q15 17020708 `"Matkamlagir"', modify
label define s1q15 17020709 `"Beriotar"', modify
label define s1q15 17020710 `"Bakok"', modify
label define s1q15 17020711 `"Lambom"', modify
label define s1q15 17020712 `"Lamassa"', modify
label define s1q15 17020713 `"Kabaman"', modify
label define s1q15 17020714 `"Kait"', modify
label define s1q15 17020715 `"Watpi"', modify
label define s1q15 17020716 `"Tambakar"', modify
label define s1q15 17020717 `"Siaman"', modify
label define s1q15 17020801 `"Taonsip"', modify
label define s1q15 17020802 `"Fonli"', modify
label define s1q15 17020803 `"Kamunaseo"', modify
label define s1q15 17020804 `"Amfar"', modify
label define s1q15 17020805 `"Sungkin"', modify
label define s1q15 17020806 `"Put"', modify
label define s1q15 17020807 `"Nonu"', modify
label define s1q15 17020808 `"Lif"', modify
label define s1q15 17020809 `"Tefa"', modify
label define s1q15 17020810 `"Natong"', modify
label define s1q15 17020811 `"Basakala"', modify
label define s1q15 17020812 `"Balankolen"', modify
label define s1q15 17020813 `"Kamgot"', modify
label define s1q15 17020814 `"Balangit"', modify
label define s1q15 17020901 `"Londolovit"', modify
label define s1q15 17020902 `"Puput"', modify
label define s1q15 17020903 `"Matakues"', modify
label define s1q15 17020904 `"Lataul"', modify
label define s1q15 17020905 `"Komat"', modify
label define s1q15 17020906 `"Pangoh"', modify
label define s1q15 17020907 `"Hurtol"', modify
label define s1q15 17020908 `"Samo"', modify
label define s1q15 17020909 `"Lamboar"', modify
label define s1q15 17020910 `"Kosmaium"', modify
label define s1q15 17020911 `"Kuanie"', modify
label define s1q15 17020912 `"Malie"', modify
label define s1q15 17020913 `"Malal"', modify
label define s1q15 17020914 `"Ton"', modify
label define s1q15 17020915 `"Mahur"', modify
label define s1q15 17020984 `"Londolovit Township"', modify
label define s1q15 18010101 `"Napapar No.1"', modify
label define s1q15 18010102 `"Napapar No.2"', modify
label define s1q15 18010103 `"Napapar No.3"', modify
label define s1q15 18010104 `"Napapar No. 4"', modify
label define s1q15 18010105 `"Napapar No. 5"', modify
label define s1q15 18010106 `"Vunagogo"', modify
label define s1q15 18010107 `"Takekel"', modify
label define s1q15 18010108 `"Kadakada"', modify
label define s1q15 18010109 `"Rakunai"', modify
label define s1q15 18010110 `"Latlat"', modify
label define s1q15 18010111 `"Navunaram"', modify
label define s1q15 18010112 `"Tavui-Liu"', modify
label define s1q15 18010113 `"Malmaluan"', modify
label define s1q15 18010114 `"Karavia No.I"', modify
label define s1q15 18010115 `"Karavia No.2"', modify
label define s1q15 18010116 `"Tavilo Settlement"', modify
label define s1q15 18010117 `"Talakua"', modify
label define s1q15 18010118 `"Kerevat Township"', modify
label define s1q15 18010119 `"Tinganagalip"', modify
label define s1q15 18010182 `"Kerevat Urban"', modify
label define s1q15 18010201 `"Alaskam"', modify
label define s1q15 18010202 `"Lamarin"', modify
label define s1q15 18010203 `"Raunsepna"', modify
label define s1q15 18010204 `"Yayami"', modify
label define s1q15 18010205 `"Malasaet"', modify
label define s1q15 18010206 `"Burit"', modify
label define s1q15 18010207 `"Nanapki"', modify
label define s1q15 18010208 `"Liaga"', modify
label define s1q15 18010209 `"Kereba"', modify
label define s1q15 18010210 `"Vudal"', modify
label define s1q15 18010211 `"Vunapalading No.1"', modify
label define s1q15 18010212 `"Vunapalading No.2"', modify
label define s1q15 18010213 `"Rangulit"', modify
label define s1q15 18010214 `"Lamarainam"', modify
label define s1q15 18010215 `"Mandressem Sett"', modify
label define s1q15 18010216 `"Lulit"', modify
label define s1q15 18010217 `"Radingi"', modify
label define s1q15 18010218 `"Kamanakam"', modify
label define s1q15 18010219 `"Ragaga"', modify
label define s1q15 18010220 `"Rhungagi"', modify
label define s1q15 18010222 `"Kadaulung No.2"', modify
label define s1q15 18010223 `"Vungi"', modify
label define s1q15 18010224 `"Gaulim"', modify
label define s1q15 18010225 `"Kainagunan"', modify
label define s1q15 18010226 `"Ivere"', modify
label define s1q15 18010227 `"Malabonga"', modify
label define s1q15 18010301 `"Poniar/Kanako"', modify
label define s1q15 18010302 `"Mobilum"', modify
label define s1q15 18010303 `"Takis"', modify
label define s1q15 18010304 `"Nangasn"', modify
label define s1q15 18010305 `"Traiwara"', modify
label define s1q15 18010306 `"Lassul"', modify
label define s1q15 18010307 `"Puktas"', modify
label define s1q15 18010308 `"Karo"', modify
label define s1q15 18010309 `"Matanakunai"', modify
label define s1q15 18010310 `"Mandrambit"', modify
label define s1q15 18010311 `"Wilambemki/Poiniara"', modify
label define s1q15 18010312 `"Panarupkap"', modify
label define s1q15 18010313 `"Laan"', modify
label define s1q15 18010314 `"Yalom"', modify
label define s1q15 18010315 `"Komgi"', modify
label define s1q15 18010316 `"Naviu/Mamapit"', modify
label define s1q15 18010317 `"Open Bay Timbers"', modify
label define s1q15 18010318 `"Walmetki"', modify
label define s1q15 18010319 `"Kolopom Settlement"', modify
label define s1q15 18010320 `"Warakindam"', modify
label define s1q15 18010321 `"Morokindam"', modify
label define s1q15 18010322 `"Mobisberg Plantation"', modify
label define s1q15 18010401 `"Rababat"', modify
label define s1q15 18010402 `"Vunairoto"', modify
label define s1q15 18010403 `"Kabakada"', modify
label define s1q15 18010404 `"Nabata"', modify
label define s1q15 18010405 `"Toboina"', modify
label define s1q15 18010406 `"Raluan No.3"', modify
label define s1q15 18010407 `"Putanagororoi"', modify
label define s1q15 18010408 `"Vunalir"', modify
label define s1q15 18010409 `"Ratongor"', modify
label define s1q15 18010410 `"Vunadavai"', modify
label define s1q15 18010411 `"Lungalunga"', modify
label define s1q15 18010412 `"Mei-Livuan"', modify
label define s1q15 18010413 `"Volavolo"', modify
label define s1q15 18010414 `"Kuraip"', modify
label define s1q15 18010415 `"Vunalaka"', modify
label define s1q15 18010416 `"Vunakalkalulu"', modify
label define s1q15 18010417 `"Taranga"', modify
label define s1q15 18010418 `"Raburbur"', modify
label define s1q15 18010419 `"Rakotop"', modify
label define s1q15 18010420 `"Ramalmal"', modify
label define s1q15 18010421 `"Vunailaiting"', modify
label define s1q15 18010422 `"Vunakainalama"', modify
label define s1q15 18010423 `"Towaleka"', modify
label define s1q15 18010424 `"Ramale"', modify
label define s1q15 18010425 `"Kikitabu"', modify
label define s1q15 18010426 `"Vunaulaiting"', modify
label define s1q15 18010427 `"Totovel"', modify
label define s1q15 18010428 `"Rakada"', modify
label define s1q15 18010429 `"Vunapaka"', modify
label define s1q15 18010502 `"Rabagi No.1"', modify
label define s1q15 18010503 `"Rabagi No.2"', modify
label define s1q15 18010505 `"Rapitok No.1"', modify
label define s1q15 18010506 `"Rapitok No.2"', modify
label define s1q15 18010507 `"Rapitok No.3"', modify
label define s1q15 18010508 `"Rapitok No.4"', modify
label define s1q15 18010509 `"Ratavul"', modify
label define s1q15 18010510 `"Vunakabi"', modify
label define s1q15 18010511 `"Tanaka"', modify
label define s1q15 18010512 `"Taulil No.1"', modify
label define s1q15 18010513 `"Taulil No.2"', modify
label define s1q15 18010514 `"Vunadidir"', modify
label define s1q15 18010515 `"Bitakapuk No.1"', modify
label define s1q15 18010516 `"Bitakapuk No.2"', modify
label define s1q15 18010517 `"Tagitagi No.1"', modify
label define s1q15 18010518 `"Tagitagi No.2"', modify
label define s1q15 18010519 `"Wariki No.1"', modify
label define s1q15 18010520 `"Wariki No.2"', modify
label define s1q15 18010521 `"Wariki No.3"', modify
label define s1q15 18010522 `"Wariki No. 4"', modify
label define s1q15 18010523 `"Viviran No.1"', modify
label define s1q15 18010524 `"Viviran No.2"', modify
label define s1q15 18010525 `"Vunakaur"', modify
label define s1q15 18010526 `"Baie"', modify
label define s1q15 18010527 `"Papalaba"', modify
label define s1q15 18010528 `"Vunararere"', modify
label define s1q15 18010529 `"Tamanairik No.1"', modify
label define s1q15 18010530 `"Tamanairik No.2"', modify
label define s1q15 18010531 `"Rabata"', modify
label define s1q15 18020601 `"Tavui No.1"', modify
label define s1q15 18020602 `"Tavui No.2"', modify
label define s1q15 18020603 `"Balada"', modify
label define s1q15 18020604 `"Ratavul"', modify
label define s1q15 18020605 `"Ralubang"', modify
label define s1q15 18020606 `"Togoro"', modify
label define s1q15 18020607 `"Tabuna"', modify
label define s1q15 18020608 `"Katakatai"', modify
label define s1q15 18020609 `"Vunabaur"', modify
label define s1q15 18020610 `"Watwat"', modify
label define s1q15 18020611 `"Londip"', modify
label define s1q15 18020612 `"Ganai"', modify
label define s1q15 18020613 `"Marmar"', modify
label define s1q15 18020614 `"Menebunbun"', modify
label define s1q15 18020615 `"Bilur"', modify
label define s1q15 18020616 `"Korai"', modify
label define s1q15 18020617 `"Kamakamar"', modify
label define s1q15 18020618 `"Birar"', modify
label define s1q15 18020619 `"Makurapau"', modify
label define s1q15 18020620 `"Rainau"', modify
label define s1q15 18020621 `"Malakuna"', modify
label define s1q15 18020622 `"Ulaveo"', modify
label define s1q15 18020701 `"Makada/Nagaila"', modify
label define s1q15 18020702 `"Molot"', modify
label define s1q15 18020703 `"Maren"', modify
label define s1q15 18020704 `"Butlivuan"', modify
label define s1q15 18020705 `"Waira"', modify
label define s1q15 18020706 `"Nabual"', modify
label define s1q15 18020707 `"Inolo"', modify
label define s1q15 18020708 `"Kumaina"', modify
label define s1q15 18020709 `"Kabilomo"', modify
label define s1q15 18020710 `"Urakukur"', modify
label define s1q15 18020711 `"Kababiai"', modify
label define s1q15 18020712 `"Mualim"', modify
label define s1q15 18020713 `"Urian"', modify
label define s1q15 18020714 `"Palipal"', modify
label define s1q15 18020715 `"Utuan"', modify
label define s1q15 18020716 `"Karawara"', modify
label define s1q15 18020717 `"Paupal"', modify
label define s1q15 18020718 `"Urukuk"', modify
label define s1q15 18020719 `"Pirtop"', modify
label define s1q15 18020720 `"Nakukur No.1 &amp; 2"', modify
label define s1q15 18020721 `"Rakanda"', modify
label define s1q15 18020801 `"Karavia"', modify
label define s1q15 18020802 `"Vunamami"', modify
label define s1q15 18020803 `"Bitarebarebe"', modify
label define s1q15 18020804 `"Vunabalbal"', modify
label define s1q15 18020805 `"Gunanba"', modify
label define s1q15 18020806 `"Tinganavudu"', modify
label define s1q15 18020808 `"Ulagunan"', modify
label define s1q15 18020809 `"Livuan"', modify
label define s1q15 18020810 `"Ramale"', modify
label define s1q15 18020811 `"Bitagalip"', modify
label define s1q15 18020812 `"Kabakaul"', modify
label define s1q15 18020813 `"Takubar"', modify
label define s1q15 18020814 `"Palnakaur"', modify
label define s1q15 18020815 `"Ulaulatava"', modify
label define s1q15 18020816 `"Vunapope"', modify
label define s1q15 18020817 `"Ngunguna"', modify
label define s1q15 18020818 `"Gunanur"', modify
label define s1q15 18020819 `"Palavirua"', modify
label define s1q15 18020880 `"Kokopo Town"', modify
label define s1q15 18020901 `"Raburua"', modify
label define s1q15 18020902 `"Bitatita"', modify
label define s1q15 18020903 `"Nugvalian"', modify
label define s1q15 18020904 `"Raluana"', modify
label define s1q15 18020905 `"Barovon"', modify
label define s1q15 18020906 `"Ialakua"', modify
label define s1q15 18020907 `"Vunatagia"', modify
label define s1q15 18020908 `"Ranguina"', modify
label define s1q15 18020909 `"Bitabaur"', modify
label define s1q15 18020910 `"Vunamurmur"', modify
label define s1q15 18020912 `"Vunaulul"', modify
label define s1q15 18020913 `"Ralalar"', modify
label define s1q15 18020914 `"Turagunan"', modify
label define s1q15 18020915 `"Kunakunai"', modify
label define s1q15 18020916 `"Ngatur"', modify
label define s1q15 18020917 `"Tinganalom"', modify
label define s1q15 18020918 `"Nanuk"', modify
label define s1q15 18020919 `"Balanataman"', modify
label define s1q15 18020920 `"Ravat"', modify
label define s1q15 18020921 `"Talakua"', modify
label define s1q15 18031001 `"Parole"', modify
label define s1q15 18031002 `"Malakur"', modify
label define s1q15 18031003 `"Kerkernena"', modify
label define s1q15 18031004 `"Baien (West)"', modify
label define s1q15 18031005 `"Galue"', modify
label define s1q15 18031006 `"Marmar"', modify
label define s1q15 18031007 `"Pomio"', modify
label define s1q15 18031008 `"Olaipun"', modify
label define s1q15 18031009 `"Sali"', modify
label define s1q15 18031010 `"Bovalpun"', modify
label define s1q15 18031011 `"Kalakru"', modify
label define s1q15 18031012 `"Kawa"', modify
label define s1q15 18031013 `"Tokai"', modify
label define s1q15 18031014 `"Matong"', modify
label define s1q15 18031015 `"Buka"', modify
label define s1q15 18031016 `"Pulpul"', modify
label define s1q15 18031017 `"Pakia"', modify
label define s1q15 18031018 `"Mile"', modify
label define s1q15 18031019 `"Mukulu"', modify
label define s1q15 18031020 `"Malvoni"', modify
label define s1q15 18031021 `"Muela"', modify
label define s1q15 18031022 `"Bago"', modify
label define s1q15 18031023 `"Pakaraman"', modify
label define s1q15 18031024 `"Birigi"', modify
label define s1q15 18031025 `"Bagitave"', modify
label define s1q15 18031026 `"Kapkena"', modify
label define s1q15 18031027 `"Tuki"', modify
label define s1q15 18031028 `"Lakiri"', modify
label define s1q15 18031029 `"Marmu"', modify
label define s1q15 18031030 `"Masuari"', modify
label define s1q15 18031031 `"Manigugule"', modify
label define s1q15 18031032 `"Kavale"', modify
label define s1q15 18031033 `"Gelioi"', modify
label define s1q15 18031101 `"Lamarain"', modify
label define s1q15 18031102 `"Long"', modify
label define s1q15 18031103 `"Hoya"', modify
label define s1q15 18031104 `"Kaukum"', modify
label define s1q15 18031105 `"Milim"', modify
label define s1q15 18031106 `"Guma"', modify
label define s1q15 18031107 `"Klampun"', modify
label define s1q15 18031108 `"Sampun"', modify
label define s1q15 18031109 `"Waswas"', modify
label define s1q15 18031110 `"Bain"', modify
label define s1q15 18031111 `"Raolman"', modify
label define s1q15 18031201 `"Makmak"', modify
label define s1q15 18031202 `"Waipo"', modify
label define s1q15 18031203 `"Simi"', modify
label define s1q15 18031204 `"Tavolo"', modify
label define s1q15 18031205 `"Meletong"', modify
label define s1q15 18031206 `"Uvol"', modify
label define s1q15 18031207 `"Einahelei"', modify
label define s1q15 18031208 `"Ruachana"', modify
label define s1q15 18031209 `"Mininga"', modify
label define s1q15 18031210 `"Maso"', modify
label define s1q15 18031211 `"Esletenae"', modify
label define s1q15 18031212 `"Mainge"', modify
label define s1q15 18031213 `"Atu"', modify
label define s1q15 18031214 `"Haumakia"', modify
label define s1q15 18031215 `"Poio"', modify
label define s1q15 18031216 `"Pilematana"', modify
label define s1q15 18031217 `"Lausus"', modify
label define s1q15 18031218 `"Kenmininga"', modify
label define s1q15 18031219 `"Warale"', modify
label define s1q15 18031301 `"Rieit"', modify
label define s1q15 18031302 `"Arabam"', modify
label define s1q15 18031303 `"Maranagi"', modify
label define s1q15 18031304 `"Reigal"', modify
label define s1q15 18031305 `"Sanbum"', modify
label define s1q15 18031306 `"Marambu"', modify
label define s1q15 18031307 `"Lat"', modify
label define s1q15 18031308 `"Gar"', modify
label define s1q15 18031309 `"Merai"', modify
label define s1q15 18031310 `"Ili"', modify
label define s1q15 18031311 `"Karong"', modify
label define s1q15 18031312 `"Sunam"', modify
label define s1q15 18031313 `"Marunga"', modify
label define s1q15 18031314 `"Kavudemki"', modify
label define s1q15 18031315 `"Tol"', modify
label define s1q15 18031316 `"Sikut"', modify
label define s1q15 18031317 `"Ivon/Gore"', modify
label define s1q15 18031318 `"Laup"', modify
label define s1q15 18031319 `"Kadalung No. 1"', modify
label define s1q15 18031401 `"Gugulena"', modify
label define s1q15 18031402 `"Malmal"', modify
label define s1q15 18031403 `"Manginuna"', modify
label define s1q15 18031404 `"Totongpal"', modify
label define s1q15 18031405 `"Kaiton"', modify
label define s1q15 18031406 `"Puapal"', modify
label define s1q15 18031407 `"Rowan/Malo"', modify
label define s1q15 18031408 `"Pomai/Mu"', modify
label define s1q15 18031409 `"Poro/Salel"', modify
label define s1q15 18031410 `"Irena"', modify
label define s1q15 18031411 `"Kangelona"', modify
label define s1q15 18031412 `"Mauna"', modify
label define s1q15 18031413 `"Lau"', modify
label define s1q15 18031414 `"Bairaman"', modify
label define s1q15 18031415 `"Tolel"', modify
label define s1q15 18031416 `"Maitao"', modify
label define s1q15 18031417 `"Serenguna"', modify
label define s1q15 18031418 `"Paliavulu"', modify
label define s1q15 18031419 `"Viosopuna"', modify
label define s1q15 18031420 `"Pokapuna"', modify
label define s1q15 18031421 `"Bili"', modify
label define s1q15 18031423 `"Okempuna"', modify
label define s1q15 18031424 `"Kaitoto"', modify
label define s1q15 18031425 `"Mapuna"', modify
label define s1q15 18031426 `"Peling"', modify
label define s1q15 18031427 `"Aona"', modify
label define s1q15 18031428 `"Yauyau"', modify
label define s1q15 18031429 `"Kaikou"', modify
label define s1q15 18031430 `"Kinsena"', modify
label define s1q15 18031431 `"Ulutu"', modify
label define s1q15 18031432 `"Kerongkorona"', modify
label define s1q15 18031433 `"Sivaona"', modify
label define s1q15 18031434 `"Pepeng"', modify
label define s1q15 18041501 `"Ratung"', modify
label define s1q15 18041502 `"Pilapila"', modify
label define s1q15 18041503 `"Karavia"', modify
label define s1q15 18041504 `"Ratavul"', modify
label define s1q15 18041505 `"Volavolo"', modify
label define s1q15 18041506 `"Nonga"', modify
label define s1q15 18041507 `"Tavui No.1"', modify
label define s1q15 18041508 `"Tavui No.2"', modify
label define s1q15 18041509 `"Tavui No.3"', modify
label define s1q15 18041510 `"Malaguna No.1"', modify
label define s1q15 18041511 `"Malaguna No.2"', modify
label define s1q15 18041512 `"Malaguna No.3"', modify
label define s1q15 18041513 `"Iawakaka"', modify
label define s1q15 18041514 `"Rapolo"', modify
label define s1q15 18041515 `"Raluan No.1"', modify
label define s1q15 18041516 `"Raluan No.2"', modify
label define s1q15 18041517 `"Tavana"', modify
label define s1q15 18041518 `"Valaur"', modify
label define s1q15 18041583 `"Nonga Base Hospital"', modify
label define s1q15 18041601 `"Baai"', modify
label define s1q15 18041602 `"Nodup"', modify
label define s1q15 18041603 `"Matalau"', modify
label define s1q15 18041604 `"Rakunat"', modify
label define s1q15 18041605 `"Rabuana"', modify
label define s1q15 18041606 `"Korere 1"', modify
label define s1q15 18041607 `"Korere 2"', modify
label define s1q15 18041608 `"Talvat"', modify
label define s1q15 18041609 `"Matupit 1"', modify
label define s1q15 18041610 `"Matupit 2"', modify
label define s1q15 18041611 `"Matupit 3"', modify
label define s1q15 18041612 `"Matupit 4"', modify
label define s1q15 18041613 `"Matupit 5"', modify
label define s1q15 18041781 `"Rabaul Town"', modify
label define s1q15 18041801 `"Rakival"', modify
label define s1q15 18041802 `"Taranata"', modify
label define s1q15 18041804 `"Vunabuk"', modify
label define s1q15 18041805 `"Vunakabai"', modify
label define s1q15 18041806 `"Vunaulaiar"', modify
label define s1q15 19010101 `"Amio"', modify
label define s1q15 19010102 `"Poronga"', modify
label define s1q15 19010103 `"Tesopol"', modify
label define s1q15 19010104 `"Akolet"', modify
label define s1q15 19010105 `"Aigon"', modify
label define s1q15 19010106 `"Kasuilo"', modify
label define s1q15 19010107 `"Asirim"', modify
label define s1q15 19010201 `"Aumo"', modify
label define s1q15 19010202 `"Aisega"', modify
label define s1q15 19010203 `"Somate"', modify
label define s1q15 19010204 `"Kilenge"', modify
label define s1q15 19010205 `"Airagilpua"', modify
label define s1q15 19010206 `"Gakiu"', modify
label define s1q15 19010207 `"Alaido"', modify
label define s1q15 19010208 `"Gurrissi"', modify
label define s1q15 19010301 `"Amnge"', modify
label define s1q15 19010302 `"Apalik"', modify
label define s1q15 19010303 `"Aeglep"', modify
label define s1q15 19010304 `"Kandrian"', modify
label define s1q15 19010305 `"Kaul"', modify
label define s1q15 19010306 `"Loko Nambis"', modify
label define s1q15 19010307 `"Ioudo"', modify
label define s1q15 19010308 `"Vinum"', modify
label define s1q15 19010309 `"Pilolo"', modify
label define s1q15 19010310 `"Agulo"', modify
label define s1q15 19010311 `"Ivangnga"', modify
label define s1q15 19010312 `"Naplavui"', modify
label define s1q15 19010381 `"Kandrian Urban"', modify
label define s1q15 19010401 `"Akivru"', modify
label define s1q15 19010402 `"Gogor"', modify
label define s1q15 19010403 `"Loko Bush"', modify
label define s1q15 19010404 `"Kalakin"', modify
label define s1q15 19010405 `"Miu"', modify
label define s1q15 19010406 `"Avet"', modify
label define s1q15 19010407 `"Awon"', modify
label define s1q15 19010408 `"Amumsong"', modify
label define s1q15 19010409 `"Palan"', modify
label define s1q15 19010410 `"Asengseng"', modify
label define s1q15 19010411 `"Ngolu"', modify
label define s1q15 19010501 `"Kakota"', modify
label define s1q15 19010502 `"Talasea"', modify
label define s1q15 19010503 `"Poitala"', modify
label define s1q15 19010504 `"Kalmaruhi"', modify
label define s1q15 19010505 `"Sisili Sapulo"', modify
label define s1q15 19010506 `"Mongamonga"', modify
label define s1q15 19010507 `"Akivilik"', modify
label define s1q15 19010508 `"Lusi"', modify
label define s1q15 19010509 `"Anemsahe"', modify
label define s1q15 19010510 `"Aria No. 1"', modify
label define s1q15 19010511 `"Aria No. 2"', modify
label define s1q15 19010512 `"Mouk"', modify
label define s1q15 19010513 `"Lamogai"', modify
label define s1q15 19020601 `"Baia"', modify
label define s1q15 19020602 `"Noau"', modify
label define s1q15 19020603 `"Ubili"', modify
label define s1q15 19020604 `"Navo"', modify
label define s1q15 19020605 `"Lolobau"', modify
label define s1q15 19020606 `"Kambaia"', modify
label define s1q15 19020607 `"Barema"', modify
label define s1q15 19020608 `"Wilelo"', modify
label define s1q15 19020609 `"Apupul"', modify
label define s1q15 19020610 `"Bialla"', modify
label define s1q15 19020611 `"Tiauru"', modify
label define s1q15 19020612 `"Sale / Malasi"', modify
label define s1q15 19020613 `"Sale / Sege"', modify
label define s1q15 19020614 `"Uasilau"', modify
label define s1q15 19020615 `"Silanga"', modify
label define s1q15 19020616 `"Pasusu"', modify
label define s1q15 19020617 `"Ubae / Bilomi"', modify
label define s1q15 19020618 `"Mangaseng"', modify
label define s1q15 19020682 `"Bialla Urban"', modify
label define s1q15 19020701 `"Penata"', modify
label define s1q15 19020702 `"Garomatong"', modify
label define s1q15 19020703 `"Kumburi"', modify
label define s1q15 19020704 `"Lovanua"', modify
label define s1q15 19020705 `"Mundua"', modify
label define s1q15 19020706 `"West Garove"', modify
label define s1q15 19020707 `"East Garove"', modify
label define s1q15 19020801 `"Garua"', modify
label define s1q15 19020802 `"Kwalakesi"', modify
label define s1q15 19020803 `"Hoskins"', modify
label define s1q15 19020804 `"Kalu"', modify
label define s1q15 19020805 `"Valoka"', modify
label define s1q15 19020806 `"Rikau/Siki"', modify
label define s1q15 19020807 `"Kagagu"', modify
label define s1q15 19020808 `"Malala"', modify
label define s1q15 19020809 `"Pokili"', modify
label define s1q15 19020980 `"Kimbe Urban"', modify
label define s1q15 19021001 `"Gamapili"', modify
label define s1q15 19021002 `"Bugal"', modify
label define s1q15 19021003 `"Kavui"', modify
label define s1q15 19021004 `"Gaopore"', modify
label define s1q15 19021005 `"Laheri"', modify
label define s1q15 19021006 `"Bebere"', modify
label define s1q15 19021007 `"Tamba"', modify
label define s1q15 19021008 `"Sarakolok"', modify
label define s1q15 19021086 `"Mosa Urban"', modify
label define s1q15 19021101 `"Nalabu"', modify
label define s1q15 19021102 `"Boge"', modify
label define s1q15 19021103 `"Gabuna"', modify
label define s1q15 19021104 `"Bola"', modify
label define s1q15 19021105 `"Warou"', modify
label define s1q15 19021106 `"Tabekemeli"', modify
label define s1q15 19021107 `"Bulu"', modify
label define s1q15 19021108 `"Valupai"', modify
label define s1q15 19021109 `"Baliondo"', modify
label define s1q15 19021110 `"Bunga"', modify
label define s1q15 20010101 `"Tinputz"', modify
label define s1q15 20010102 `"Teop"', modify
label define s1q15 20010103 `"Taonita"', modify
label define s1q15 20010201 `"Islands"', modify
label define s1q15 20010202 `"Hahon"', modify
label define s1q15 20010203 `"Rapois"', modify
label define s1q15 20010204 `"Kereaka"', modify
label define s1q15 20010301 `"Sorom"', modify
label define s1q15 20010302 `"Hantoa"', modify
label define s1q15 20010303 `"Siara"', modify
label define s1q15 20010304 `"Rapoma"', modify
label define s1q15 20010305 `"Suir Coastal"', modify
label define s1q15 20010306 `"Suir Inland"', modify
label define s1q15 20010402 `"Tsitalato"', modify
label define s1q15 20010403 `"Hagogohe"', modify
label define s1q15 20010404 `"Peit"', modify
label define s1q15 20010405 `"Halia"', modify
label define s1q15 20010406 `"Haku"', modify
label define s1q15 20010407 `"Tonsu"', modify
label define s1q15 20010480 `"Buka Urban"', modify
label define s1q15 20010501 `"Tungol"', modify
label define s1q15 20010502 `"Sigon"', modify
label define s1q15 20010503 `"Pinepel"', modify
label define s1q15 20010601 `"Carterets"', modify
label define s1q15 20010602 `"Tasman"', modify
label define s1q15 20010603 `"Mortlock"', modify
label define s1q15 20010604 `"Nuguria"', modify
label define s1q15 20020702 `"Ewara / Papana"', modify
label define s1q15 20020703 `"Auta"', modify
label define s1q15 20020704 `"Rotokas"', modify
label define s1q15 20020707 `"Assigoro"', modify
label define s1q15 20020708 `"Usireio"', modify
label define s1q15 20020787 `"Wakunai Urban"', modify
label define s1q15 20020801 `"Kokoda"', modify
label define s1q15 20020802 `"Torau"', modify
label define s1q15 20020803 `"Kongara No. 1"', modify
label define s1q15 20020804 `"Kongara No. 2"', modify
label define s1q15 20020805 `"Eivo 1"', modify
label define s1q15 20020806 `"Avaipa"', modify
label define s1q15 20020807 `"Oune"', modify
label define s1q15 20020808 `"Bava Pirung"', modify
label define s1q15 20020809 `"North Nasioi"', modify
label define s1q15 20020810 `"Apiatei"', modify
label define s1q15 20020811 `"South Nasioi"', modify
label define s1q15 20020812 `"Ioro 1"', modify
label define s1q15 20020813 `"Ioro 2/Domana"', modify
label define s1q15 20020814 `"Pinei-Nari"', modify
label define s1q15 20020882 `"Arawa Urban"', modify
label define s1q15 20030901 `"Baubake"', modify
label define s1q15 20030902 `"Lugakei"', modify
label define s1q15 20030903 `"Konnou"', modify
label define s1q15 20030904 `"Makis"', modify
label define s1q15 20030905 `"Lenoke"', modify
label define s1q15 20030906 `"Wisai"', modify
label define s1q15 20031001 `"Mukakuru"', modify
label define s1q15 20031002 `"Rataiku"', modify
label define s1q15 20031003 `"Konga"', modify
label define s1q15 20031004 `"Ruhwaku"', modify
label define s1q15 20031005 `"Korikunu"', modify
label define s1q15 20031006 `"Hari"', modify
label define s1q15 20031007 `"Tokunutu"', modify
label define s1q15 20031008 `"Huyono"', modify
label define s1q15 20031009 `"Motuna"', modify
label define s1q15 20031101 `"Baitsi"', modify
label define s1q15 20031102 `"Lamane East"', modify
label define s1q15 20031103 `"Lamane South"', modify
label define s1q15 20031104 `"Telepi"', modify
label define s1q15 20031105 `"Tomau"', modify
label define s1q15 20031106 `"Velipe"', modify
label define s1q15 20031107 `"Gooreh"', modify
label define s1q15 20031108 `"Toberaki"', modify
label define s1q15 20031201 `"Burue"', modify
label define s1q15 20031202 `"Naghareghe"', modify
label define s1q15 20031205 `"Atsinima"', modify
label define s1q15 20031207 `"Eivo"', modify
label define s1q15 21041101 `"Alua/Kambi"', modify
label define s1q15 21041102 `"Kela"', modify
label define s1q15 21041103 `"Uruma"', modify
label define s1q15 21041104 `"Piangwanda"', modify
label define s1q15 21041105 `"Puju"', modify
label define s1q15 21041106 `"Tigibi 1"', modify
label define s1q15 21041107 `"Wabia 2"', modify
label define s1q15 21041108 `"Wabia 1"', modify
label define s1q15 21041109 `"Iangome"', modify
label define s1q15 21041110 `"Damita 1"', modify
label define s1q15 21041111 `"Hol'la"', modify
label define s1q15 21041112 `"Dimu"', modify
label define s1q15 21041113 `"Homa Pawa"', modify
label define s1q15 21041114 `"Honaga"', modify
label define s1q15 21041115 `"Lau'u"', modify
label define s1q15 21041116 `"Pagale"', modify
label define s1q15 21041117 `"Yabagaru"', modify
label define s1q15 21041118 `"Davi Davi"', modify
label define s1q15 21041119 `"Kuyali"', modify
label define s1q15 21041120 `"Yarale"', modify
label define s1q15 21041121 `"Hogombe"', modify
label define s1q15 21041122 `"Tigibi 3"', modify
label define s1q15 21041123 `"Dauli 1"', modify
label define s1q15 21041124 `"Damita 2"', modify
label define s1q15 21041125 `"Dauli 2"', modify
label define s1q15 21041126 `"Dauli 3"', modify
label define s1q15 21041127 `"Peri"', modify
label define s1q15 21041129 `"Wabia 3"', modify
label define s1q15 21041201 `"Atare"', modify
label define s1q15 21041202 `"Tumbite Ayagare"', modify
label define s1q15 21041203 `"Egauwi"', modify
label define s1q15 21041204 `"Eanda"', modify
label define s1q15 21041205 `"Pami"', modify
label define s1q15 21041206 `"Egaipa"', modify
label define s1q15 21041208 `"Ayagate"', modify
label define s1q15 21041209 `"Kulu Nogoli"', modify
label define s1q15 21041210 `"Emberali"', modify
label define s1q15 21041211 `"Padua"', modify
label define s1q15 21041213 `"Agu/Tani"', modify
label define s1q15 21041214 `"Laiyako"', modify
label define s1q15 21041215 `"Para"', modify
label define s1q15 21041216 `"Laite"', modify
label define s1q15 21041217 `"Mindirate"', modify
label define s1q15 21041218 `"Pura"', modify
label define s1q15 21041219 `"Turubi Tawanda"', modify
label define s1q15 21041220 `"Tumbite Ligame"', modify
label define s1q15 21041221 `"Yandare"', modify
label define s1q15 21041222 `"Komo Rural Station"', modify
label define s1q15 21041301 `"Sebiba"', modify
label define s1q15 21041302 `"Wabal"', modify
label define s1q15 21041303 `"Henep"', modify
label define s1q15 21041304 `"Ombal"', modify
label define s1q15 21041305 `"Songura"', modify
label define s1q15 21041306 `"Solapaem"', modify
label define s1q15 21041307 `"Kapendaka"', modify
label define s1q15 21041313 `"Pingi"', modify
label define s1q15 21041321 `"Yambaraka"', modify
label define s1q15 21041322 `"Wabulaka"', modify
label define s1q15 21041323 `"Olaem"', modify
label define s1q15 21041324 `"Posera"', modify
label define s1q15 21041325 `"Mabera"', modify
label define s1q15 21041326 `"Weya"', modify
label define s1q15 21041335 `"Keme"', modify
label define s1q15 21041336 `"Hone"', modify
label define s1q15 21043108 `"Homaria"', modify
label define s1q15 21043109 `"Tuya"', modify
label define s1q15 21043110 `"Mabia"', modify
label define s1q15 21043111 `"Tengo"', modify
label define s1q15 21043114 `"Tabala"', modify
label define s1q15 21043115 `"Wambia"', modify
label define s1q15 21043116 `"Ugu 1"', modify
label define s1q15 21043117 `"Ugu 2"', modify
label define s1q15 21043118 `"Yanagere"', modify
label define s1q15 21043119 `"Yuhoma"', modify
label define s1q15 21043120 `"Yongo"', modify
label define s1q15 21043127 `"Ariaka"', modify
label define s1q15 21043128 `"Panduaga 1"', modify
label define s1q15 21043129 `"Panduaga 2/ Piangai"', modify
label define s1q15 21043130 `"Tawanda"', modify
label define s1q15 21043131 `"Liuliu"', modify
label define s1q15 21043132 `"Tundaka"', modify
label define s1q15 21043133 `"Yongale"', modify
label define s1q15 21043134 `"Margarima"', modify
label define s1q15 21043135 `"Pipi"', modify
label define s1q15 21043136 `"Kungu"', modify
label define s1q15 21051401 `"Ti'iba"', modify
label define s1q15 21051402 `"Tapayamapu"', modify
label define s1q15 21051403 `"Kuranda 2"', modify
label define s1q15 21051404 `"Kuranda 1"', modify
label define s1q15 21051405 `"Tade 2 (Wagia)"', modify
label define s1q15 21051406 `"Tade 1"', modify
label define s1q15 21051407 `"Wagala"', modify
label define s1q15 21051408 `"Eganda"', modify
label define s1q15 21051409 `"Ayuguali 1"', modify
label define s1q15 21051410 `"Ayugali 2"', modify
label define s1q15 21051411 `"Wanga Pareya"', modify
label define s1q15 21051412 `"Tugu"', modify
label define s1q15 21051413 `"Hamuta"', modify
label define s1q15 21051414 `"Puyena"', modify
label define s1q15 21051415 `"Kewe 1"', modify
label define s1q15 21051416 `"Kewe 2"', modify
label define s1q15 21051417 `"Embe"', modify
label define s1q15 21051418 `"Wanga"', modify
label define s1q15 21051419 `"Paga"', modify
label define s1q15 21051420 `"Hawinda 1"', modify
label define s1q15 21051421 `"Hirubala"', modify
label define s1q15 21051422 `"Hawinda 2"', modify
label define s1q15 21051423 `"Kutage"', modify
label define s1q15 21051424 `"Waluni/Tarane"', modify
label define s1q15 21051501 `"Haredege"', modify
label define s1q15 21051502 `"Arou"', modify
label define s1q15 21051503 `"Hagini/Poko"', modify
label define s1q15 21051504 `"Horale/Karuka"', modify
label define s1q15 21051505 `"Aluni"', modify
label define s1q15 21051506 `"Agali/Bulako"', modify
label define s1q15 21051507 `"Hirane/Barae"', modify
label define s1q15 21051508 `"Alukuni"', modify
label define s1q15 21051509 `"Kopiago Station"', modify
label define s1q15 21051510 `"Suwaka"', modify
label define s1q15 21051511 `"Dolowa/Hukuni"', modify
label define s1q15 21051512 `"Dilini"', modify
label define s1q15 21051513 `"Peragola"', modify
label define s1q15 21051514 `"Wagia"', modify
label define s1q15 21051515 `"Usai/Malieli"', modify
label define s1q15 21051516 `"Wiski"', modify
label define s1q15 21051517 `"Wanakipi"', modify
label define s1q15 21051518 `"Ambi"', modify
label define s1q15 21051519 `"Yokona"', modify
label define s1q15 21051601 `"Kelabo 1"', modify
label define s1q15 21051602 `"Kelabo 2"', modify
label define s1q15 21051603 `"Kudjebi"', modify
label define s1q15 21051604 `"Hawinda"', modify
label define s1q15 21051605 `"Aienda"', modify
label define s1q15 21051606 `"Kagoma"', modify
label define s1q15 21051607 `"Warukumu"', modify
label define s1q15 21051608 `"Kenamo"', modify
label define s1q15 21051609 `"Piangonga 2"', modify
label define s1q15 21051610 `"Piangoga 1"', modify
label define s1q15 21051611 `"Jakuabi"', modify
label define s1q15 21051612 `"Levani"', modify
label define s1q15 21051613 `"Betege 2"', modify
label define s1q15 21051614 `"Ereiba 2"', modify
label define s1q15 21051615 `"Ereiba 1"', modify
label define s1q15 21051616 `"Kereneiba"', modify
label define s1q15 21051617 `"Betege 1"', modify
label define s1q15 21051618 `"Hujanoma 2"', modify
label define s1q15 21051619 `"Hujanoma 1"', modify
label define s1q15 21051620 `"Teria 2"', modify
label define s1q15 21051621 `"Teria 1"', modify
label define s1q15 21051622 `"Yatemali"', modify
label define s1q15 21051623 `"Yaluba 1"', modify
label define s1q15 21051624 `"Yaluba 2"', modify
label define s1q15 21051625 `"Umimi"', modify
label define s1q15 21051701 `"Magara 1"', modify
label define s1q15 21051702 `"Erebo"', modify
label define s1q15 21051704 `"Hedemari 1"', modify
label define s1q15 21051705 `"Hedemari 2"', modify
label define s1q15 21051706 `"Humburu 1"', modify
label define s1q15 21051707 `"Humburu 2"', modify
label define s1q15 21051708 `"Kakarane 1"', modify
label define s1q15 21051712 `"Pandu"', modify
label define s1q15 21051713 `"Maria"', modify
label define s1q15 21051714 `"Andiriai 1"', modify
label define s1q15 21051715 `"Koroba Station"', modify
label define s1q15 21051716 `"Andiriai 2"', modify
label define s1q15 21051717 `"Kundugu"', modify
label define s1q15 21051718 `"Tangimabul"', modify
label define s1q15 21051719 `"Tumbite"', modify
label define s1q15 21051720 `"Pabulumu 1"', modify
label define s1q15 21051721 `"Egele 1"', modify
label define s1q15 21051722 `"Egele 2"', modify
label define s1q15 21051723 `"Mbuli"', modify
label define s1q15 21082701 `"Hare"', modify
label define s1q15 21082702 `"Munima/Wenani"', modify
label define s1q15 21082703 `"Tani Walete/ Taunda"', modify
label define s1q15 21082704 `"Halimbu"', modify
label define s1q15 21082706 `"Hambuari"', modify
label define s1q15 21082707 `"Linabeni"', modify
label define s1q15 21082708 `"Peri"', modify
label define s1q15 21082709 `"Kutama"', modify
label define s1q15 21082711 `"Hiwanda"', modify
label define s1q15 21082712 `"Mindiratogo /Hiwanda 2"', modify
label define s1q15 21082713 `"Telabo"', modify
label define s1q15 21082715 `"Undupi"', modify
label define s1q15 21082716 `"Gugubalu / Hundupi"', modify
label define s1q15 21082718 `"Teni (Hundupi)"', modify
label define s1q15 21082719 `"Agau /Teni 2"', modify
label define s1q15 21082720 `"Idauwi /Teni 3"', modify
label define s1q15 21082721 `"Yapira / Idawi"', modify
label define s1q15 21082801 `"Halongali"', modify
label define s1q15 21082802 `"Hava"', modify
label define s1q15 21082804 `"Peta-Porogorali"', modify
label define s1q15 21082805 `"Munima"', modify
label define s1q15 21082806 `"Karita 1"', modify
label define s1q15 21082807 `"Karita 2"', modify
label define s1q15 21082808 `"Henganda 1"', modify
label define s1q15 21082809 `"Henganda 2"', modify
label define s1q15 21082810 `"Mbuli"', modify
label define s1q15 21082811 `"Eganda"', modify
label define s1q15 21082812 `"Kongiabi"', modify
label define s1q15 21082813 `"Kayakali"', modify
label define s1q15 21082814 `"Paijaka 1"', modify
label define s1q15 21082815 `"Paijaka 2"', modify
label define s1q15 21082816 `"Hariba"', modify
label define s1q15 21082817 `"Tulupu Manopi"', modify
label define s1q15 21082818 `"Pii Nakia"', modify
label define s1q15 21082819 `"Mt. Kare 1"', modify
label define s1q15 21082820 `"Mt. Kare 2"', modify
label define s1q15 21082904 `"Kikita 2"', modify
label define s1q15 21082906 `"Kupari"', modify
label define s1q15 21082907 `"Yulubate/Tari 1"', modify
label define s1q15 21083002 `"Itapu"', modify
label define s1q15 21083003 `"Hangapo 1"', modify
label define s1q15 21083004 `"Hangapo 2"', modify
label define s1q15 21083005 `"Andawale 1"', modify
label define s1q15 21083006 `"Kela 1"', modify
label define s1q15 21083007 `"Kela 2"', modify
label define s1q15 21083010 `"Parinamu 2"', modify
label define s1q15 21083012 `"Kuku 2"', modify
label define s1q15 21083013 `"Kuku 3"', modify
label define s1q15 21083014 `"Hewate 1"', modify
label define s1q15 21083015 `"Hewate 2"', modify
label define s1q15 21083017 `"Kuandi 2"', modify
label define s1q15 21083018 `"Pai 2"', modify
label define s1q15 22010101 `"Kaip 1"', modify
label define s1q15 22010102 `"Kaip 2"', modify
label define s1q15 22010103 `"Kaip 3"', modify
label define s1q15 22010104 `"Polga 1"', modify
label define s1q15 22010105 `"Polga 2"', modify
label define s1q15 22010106 `"Wurup 1"', modify
label define s1q15 22010107 `"Wurup 2"', modify
label define s1q15 22010108 `"Wurup 3"', modify
label define s1q15 22010110 `"Kiliga 1"', modify
label define s1q15 22010111 `"Kiliga 2"', modify
label define s1q15 22010112 `"Ulya"', modify
label define s1q15 22010114 `"Panga"', modify
label define s1q15 22010115 `"Kutubugl 1"', modify
label define s1q15 22010116 `"Komon"', modify
label define s1q15 22010117 `"Kutubugl 2"', modify
label define s1q15 22010118 `"Ketepung 1"', modify
label define s1q15 22010119 `"Ketepung 2"', modify
label define s1q15 22010120 `"Rogomp 1"', modify
label define s1q15 22010121 `"Rogomp 2"', modify
label define s1q15 22010122 `"Ketepam 1"', modify
label define s1q15 22010123 `"Ketepam 2"', modify
label define s1q15 22010124 `"Ketepam 3"', modify
label define s1q15 22010125 `"Rukraka"', modify
label define s1q15 22010126 `"Papen"', modify
label define s1q15 22010127 `"Kindeng 1"', modify
label define s1q15 22010128 `"Kindeng 2"', modify
label define s1q15 22010129 `"Mugamamp"', modify
label define s1q15 22010130 `"Mandan"', modify
label define s1q15 22010131 `"Avi  1"', modify
label define s1q15 22010132 `"Avi 2"', modify
label define s1q15 22010133 `"Dopdop 1"', modify
label define s1q15 22010134 `"Dopdop 2"', modify
label define s1q15 22010135 `"Dopdop 3"', modify
label define s1q15 22010201 `"Aviamp 3"', modify
label define s1q15 22010202 `"Aviamp 4"', modify
label define s1q15 22010203 `"Aviamp 2"', modify
label define s1q15 22010204 `"Aviamp 1"', modify
label define s1q15 22010205 `"Kauwi"', modify
label define s1q15 22010206 `"Kabagang"', modify
label define s1q15 22010207 `"Kungar 2"', modify
label define s1q15 22010208 `"Kungar 1"', modify
label define s1q15 22010209 `"Kudjip Plnt"', modify
label define s1q15 22010210 `"Kudjip Hospital"', modify
label define s1q15 22010211 `"Puri"', modify
label define s1q15 22010212 `"Kurumul 1"', modify
label define s1q15 22010213 `"Kurumul 2"', modify
label define s1q15 22010214 `"Tombil 1"', modify
label define s1q15 22010215 `"Tombil 2"', modify
label define s1q15 22010216 `"Kamang 1"', modify
label define s1q15 22010217 `"Kamang 2"', modify
label define s1q15 22010218 `"Anginmol"', modify
label define s1q15 22010220 `"Ngunba Tsents"', modify
label define s1q15 22010221 `"Gabinal"', modify
label define s1q15 22010222 `"Alua"', modify
label define s1q15 22010223 `"Gagwa / Dup"', modify
label define s1q15 22010224 `"Kamang  3 / Mondomil"', modify
label define s1q15 22010225 `"Olubus"', modify
label define s1q15 22010226 `"Pabamil"', modify
label define s1q15 22010227 `"Tsigmil"', modify
label define s1q15 22010228 `"Begbe"', modify
label define s1q15 22010229 `"Tumba"', modify
label define s1q15 22010230 `"Numgil"', modify
label define s1q15 22010231 `"Kugmar"', modify
label define s1q15 22010232 `"Gugmar"', modify
label define s1q15 22010233 `"Djek"', modify
label define s1q15 22010234 `"Yeu  1"', modify
label define s1q15 22010235 `"Mt. Au"', modify
label define s1q15 22010236 `"Ambopane"', modify
label define s1q15 22010237 `"Yeu  2"', modify
label define s1q15 22010238 `"Olate"', modify
label define s1q15 22010239 `"Palti"', modify
label define s1q15 22010240 `"Tesa"', modify
label define s1q15 22010241 `"Wusinge"', modify
label define s1q15 22010242 `"Meru"', modify
label define s1q15 22010243 `"Tandambak"', modify
label define s1q15 22010244 `"Tun"', modify
label define s1q15 22010245 `"Kupa"', modify
label define s1q15 22010247 `"Minj Mu"', modify
label define s1q15 22010248 `"Kia"', modify
label define s1q15 22010282 `"Minj Urban"', modify
label define s1q15 22040601 `"Mogini"', modify
label define s1q15 22040602 `"Koriom"', modify
label define s1q15 22040603 `"Kwiop"', modify
label define s1q15 22040604 `"Togoban"', modify
label define s1q15 22040605 `"Kwima"', modify
label define s1q15 22040606 `"Kupeng"', modify
label define s1q15 22040607 `"Kompiai"', modify
label define s1q15 22040608 `"Tswenkai"', modify
label define s1q15 22040609 `"Bokopai"', modify
label define s1q15 22040610 `"Yumbigema"', modify
label define s1q15 22040611 `"Koinambe"', modify
label define s1q15 22040612 `"Kandabiamb"', modify
label define s1q15 22040613 `"Tsembant"', modify
label define s1q15 22040614 `"Gunjiji"', modify
label define s1q15 22040615 `"Gondobend"', modify
label define s1q15 22040616 `"Waim"', modify
label define s1q15 22040617 `"Tsarep"', modify
label define s1q15 22040618 `"Marent"', modify
label define s1q15 22040619 `"Tsendiap"', modify
label define s1q15 22040620 `"Tumbunki"', modify
label define s1q15 22040621 `"Runimp"', modify
label define s1q15 22040622 `"Wum"', modify
label define s1q15 22040623 `"Tsenga"', modify
label define s1q15 22040624 `"Maikmol"', modify
label define s1q15 22040625 `"Toli"', modify
label define s1q15 22040626 `"Ongolmol"', modify
label define s1q15 22040627 `"Kaul"', modify
label define s1q15 22040628 `"Karap"', modify
label define s1q15 22040629 `"Manemp"', modify
label define s1q15 22040630 `"Magin"', modify
label define s1q15 22040631 `"Korenju"', modify
label define s1q15 22040632 `"Tabibuga"', modify
label define s1q15 22040633 `"Tsingoropa"', modify
label define s1q15 22040634 `"Kwipun"', modify
label define s1q15 22040635 `"Telta"', modify
label define s1q15 22040636 `"Menjim No.2"', modify
label define s1q15 22040701 `"Maipka/Kol Station"', modify
label define s1q15 22040702 `"Wamku"', modify
label define s1q15 22040703 `"Kuimin"', modify
label define s1q15 22040704 `"Meginapol"', modify
label define s1q15 22040705 `"Mongom"', modify
label define s1q15 22040706 `"Maime"', modify
label define s1q15 22040707 `"Kunomol"', modify
label define s1q15 22040708 `"Kuma"', modify
label define s1q15 22040709 `"Gebal"', modify
label define s1q15 22040710 `"Iwaramul"', modify
label define s1q15 22040711 `"Dungo"', modify
label define s1q15 22040712 `"Bubulsinga"', modify
label define s1q15 22040713 `"Omun"', modify
label define s1q15 22040714 `"Kalimbkul"', modify
label define s1q15 22040715 `"Bubkale"', modify
label define s1q15 22040716 `"Bial"', modify
label define s1q15 22040717 `"Kosap"', modify
label define s1q15 22040718 `"Kurunga"', modify
label define s1q15 22040719 `"Kaulo"', modify
label define s1q15 22040720 `"Mokuna"', modify
label define s1q15 22040721 `"Yambdop"', modify
label define s1q15 22040722 `"Waramanz 1"', modify
label define s1q15 22040723 `"Waramanz 2"', modify
label define s1q15 22040724 `"Gakip"', modify
label define s1q15 22040725 `"Junk/Arbid"', modify
label define s1q15 22061101 `"Kimil 1"', modify
label define s1q15 22061102 `"Kimil No. 2"', modify
label define s1q15 22061103 `"Bung 1"', modify
label define s1q15 22061104 `"Koskala 2"', modify
label define s1q15 22061105 `"Koskala 1"', modify
label define s1q15 22061106 `"Kakinjep"', modify
label define s1q15 22061107 `"Molka 1"', modify
label define s1q15 22061109 `"Kwiena 1"', modify
label define s1q15 22061110 `"Kwiena  2"', modify
label define s1q15 22061111 `"Dumbola 1"', modify
label define s1q15 22061112 `"Talu 1"', modify
label define s1q15 22061113 `"Kendu 1"', modify
label define s1q15 22061114 `"Bolimba"', modify
label define s1q15 22061115 `"Bung 2"', modify
label define s1q15 22061116 `"Bung 3"', modify
label define s1q15 22061117 `"Koskala 3"', modify
label define s1q15 22061118 `"Kakinjep 2"', modify
label define s1q15 22061119 `"Molka 2"', modify
label define s1q15 22061120 `"Dumbola 2"', modify
label define s1q15 22061121 `"Talu 2"', modify
label define s1q15 22061122 `"Kendu 2"', modify
label define s1q15 22061123 `"Bolimba 3"', modify
label define s1q15 22061124 `"Kakinjep 3"', modify
label define s1q15 22061180 `"Banz Town"', modify
label define s1q15 22061501 `"Bamna/Bamuna 1"', modify
label define s1q15 22061502 `"Bamna/Bamuna 2"', modify
label define s1q15 22061503 `"Domil 1"', modify
label define s1q15 22061504 `"Domil 2"', modify
label define s1q15 22061505 `"Kapalku 1"', modify
label define s1q15 22061506 `"Kapalku 2"', modify
label define s1q15 22061507 `"Kaming 1"', modify
label define s1q15 22061508 `"Kombulno 1"', modify
label define s1q15 22061509 `"Kombulno 2"', modify
label define s1q15 22061510 `"Kombulno 3"', modify
label define s1q15 22061511 `"Kumbal 1"', modify
label define s1q15 22061512 `"Kumbal 2"', modify
label define s1q15 22061513 `"Milep 1"', modify
label define s1q15 22061514 `"Milep 2"', modify
label define s1q15 22061515 `"Munumul 1"', modify
label define s1q15 22061516 `"Munumul 2"', modify
label define s1q15 22061517 `"Munumul 3"', modify
label define s1q15 22061518 `"Nondugl 1"', modify
label define s1q15 22061519 `"Nondugl 2"', modify
label define s1q15 22061520 `"Ngumbkora"', modify
label define s1q15 22061521 `"Onil 1"', modify
label define s1q15 90000001 `"Other Specify"', modify
label define s1q15 90000002 `"Other Specify"', modify
label define s1q15 90000003 `"Other Specify"', modify
label define s1q15 90000004 `"Other Specify"', modify
label define s1q15 90000005 `"Other Specify"', modify
label define s1q15 90000006 `"Other Specify"', modify
label define s1q15 90000007 `"Other Specify"', modify
label define s1q15 90000008 `"Other Specify"', modify
label define s1q15 90000009 `"Other Specify"', modify
label define s1q15 90000010 `"Other Specify"', modify
label define s1q15 90000011 `"Other Specify"', modify
label define s1q15 90000012 `"Other Specify"', modify
label define s1q15 90000013 `"Other Specify"', modify
label define s1q15 90000014 `"Other Specify"', modify
label define s1q15 90000015 `"Other Specify"', modify
label define s1q15 90000016 `"Other Specify"', modify
label define s1q15 90000017 `"Other Specify"', modify
label define s1q15 90000018 `"Other Specify"', modify
label define s1q15 90000019 `"Other Specify"', modify
label define s1q15 90000020 `"Other Specify"', modify
label define s1q15 90000021 `"Other Specify"', modify
label define s1q15 90000022 `"Other Specify"', modify
label define s1q15 90000023 `"Other Specify"', modify
label define s1q15 90000024 `"Other Specify"', modify
label define s1q15 90000025 `"Other Specify"', modify
label define s1q15 90000026 `"Other Specify"', modify
label define s1q15 90000027 `"Other Specify"', modify
label define s1q15 90000028 `"Other Specify"', modify
label define s1q15 90000029 `"Other Specify"', modify
label define s1q15 90000030 `"Other Specify"', modify
label define s1q15 90000031 `"Other Specify"', modify
label define s1q15 90000032 `"Other Specify"', modify
label define s1q15 90000033 `"Other Specify"', modify
label define s1q15 90000034 `"Other Specify"', modify
label define s1q15 90000035 `"Other Specify"', modify
label define s1q15 90000036 `"Other Specify"', modify
label define s1q15 90000037 `"Other Specify"', modify
label define s1q15 90000038 `"Other Specify"', modify
label define s1q15 90000039 `"Other Specify"', modify
label define s1q15 90000040 `"Other Specify"', modify
label define s1q15 90000041 `"Other Specify"', modify
label define s1q15 90000042 `"Other Specify"', modify
label define s1q15 90000043 `"Other Specify"', modify
label define s1q15 90000044 `"Other Specify"', modify
label define s1q15 90000045 `"Other Specify"', modify
label define s1q15 90000046 `"Other Specify"', modify
label define s1q15 90000047 `"Other Specify"', modify
label define s1q15 90000048 `"Other Specify"', modify
label define s1q15 90000049 `"Other Specify"', modify
label define s1q15 90000050 `"Other Specify"', modify
label define s1q15 90000051 `"Other Specify"', modify
label define s1q15 90000052 `"Other Specify"', modify
label define s1q15 90000053 `"Other Specify"', modify
label define s1q15 90000054 `"Other Specify"', modify
label define s1q15 90000055 `"Other Specify"', modify
label define s1q15 90000056 `"Other Specify"', modify
label define s1q15 90000057 `"Other Specify"', modify
label define s1q15 90000058 `"Other Specify"', modify
label define s1q15 90000059 `"Other Specify"', modify
label define s1q15 90000060 `"Other Specify"', modify
label define s1q15 90000061 `"Other Specify"', modify
label define s1q15 90000062 `"Other Specify"', modify
label define s1q15 90000063 `"Other Specify"', modify
label define s1q15 90000064 `"Other Specify"', modify
label define s1q15 90000065 `"Other Specify"', modify
label define s1q15 90000066 `"Other Specify"', modify
label define s1q15 90000067 `"Other Specify"', modify
label define s1q15 90000068 `"Other Specify"', modify
label define s1q15 90000069 `"Other Specify"', modify
label define s1q15 90000070 `"Other Specify"', modify
label define s1q15 90000071 `"Other Specify"', modify
label define s1q15 90000072 `"Other Specify"', modify
label define s1q15 90000073 `"Other Specify"', modify
label define s1q15 90000074 `"Other Specify"', modify
label define s1q15 90000075 `"Other Specify"', modify
label define s1q15 90000076 `"Other Specify"', modify
label define s1q15 90000077 `"Other Specify"', modify
label define s1q15 90000078 `"Other Specify"', modify
label define s1q15 90000079 `"Other Specify"', modify
label define s1q15 90000080 `"Other Specify"', modify
label define s1q15 90000081 `"Other Specify"', modify
label define s1q15 90000082 `"Other Specify"', modify
label define s1q15 90000083 `"Other Specify"', modify
label define s1q15 90000084 `"Other Specify"', modify
label define s1q15 90000085 `"Other Specify"', modify
label define s1q15 90000086 `"Other Specify"', modify
label define s1q15 90000087 `"Other Specify"', modify
