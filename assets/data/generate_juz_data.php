<?php
$surahs = [
    "Fatiha",
    "Bakara",
    "Ali-İmran",
    "Nisa",
    "Maide",
    "En'am",
    "A'raf",
    "Enfal",
    "Tevbe",
    "Yunus",
    "Hud",
    "Yusuf",
    "Ra'd",
    "İbrahim",
    "Hicr",
    "Nahl",
    "İsra",
    "Kehf",
    "Meryem",
    "Taha",
    "Enbiya",
    "Hacc",
    "Müminun",
    "Nur",
    "Furkan",
    "Şuara",
    "Neml",
    "Kasas",
    "Ankebut",
    "Rum",
    "Lokman",
    "Secde",
    "Ahzab",
    "Sebe",
    "Fatır",
    "Yasin",
    "Saffet",
    "Sad",
    "Zümer",
    "Mümin",
    "Fussilet",
    "Şura",
    "Zuhruf",
    "Duhan",
    "Casiye",
    "Ahkaf",
    "Muhammed",
    "Feth",
    "Hucurat",
    "Kaf",
    "Zariyat",
    "Tur",
    "Necm",
    "Kamer",
    "Rahman",
    "Vakıa",
    "Hadid",
    "Mücadele",
    "Haşr",
    "Mümtehine",
    "Saff",
    "Cuma",
    "Münafıkun",
    "Tegabün",
    "Talak",
    "Tahrim",
    "Mülk",
    "Kalem",
    "Hâkka",
    "Meâric",
    "Nuh",
    "Cin",
    "Müzzemmil",
    "Müddessir",
    "Kıyame",
    "İnsan",
    "Mürselat",
    "Nebe",
    "Naziat",
    "Abese",
    "Tekvir",
    "İnfitar",
    "Mutaffifin",
    "İnşikak",
    "Buruc",
    "Tarık",
    "A'la",
    "Gaşiye",
    "Fecr",
    "Beled",
    "Şems",
    "Leyl",
    "Duha",
    "İnşirah",
    "Tin",
    "Alak",
    "Kadir",
    "Beyyine",
    "Zilzal",
    "Adiyat",
    "Karia",
    "Tekasür",
    "Asr",
    "Hümeze",
    "Fil",
    "Kureyş",
    "Maun",
    "Kevser",
    "Kafirun",
    "Nasr",
    "Tebbet",
    "İhlas",
    "Felak",
    "Nas"
  ];
  
$ayahPropertiesJson = file_get_contents('quran.json');
$ayahProperties = json_decode($ayahPropertiesJson, true, 512, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
$allJuzData = [];
$juzAyahs = [];
$pageAyahs = [];
$currentJuz = 1;
$currentPage = 0;
$ayahNo = 0;
for ($surahNumber = 1; $surahNumber <= 114; $surahNumber++) {
    $surahContent = file_get_contents("https://api.alquran.cloud/v1/surah/$surahNumber/ar.alafasy");
    $surahData = json_decode($surahContent, true, 512, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    echo "surah number: $surahNumber\n";
    if ($surahData && isset($surahData['data'])) {
        $surahAyahsDecoded = $surahData['data']['ayahs'];
        $surahAyahs = [];
        $numAyahs = count($surahAyahsDecoded);
        
        for ($i = 0; $i < $numAyahs; $i++) {
            $oldAyah = $surahAyahsDecoded[$i];
            $localAyah = $ayahProperties[$ayahNo++];

            $newAyah["surah"] = $surahs[($surahNumber - 1)];
            $page = $oldAyah["number"] > 6082 ? $oldAyah["page"] : ($oldAyah["page"] - 1);
            $newAyah["page"] = "" . $page;
            $newAyah["number"] = "" . $oldAyah["number"];            
            $newAyah["numberInSurah"] = "" . $oldAyah["numberInSurah"];            
            $newAyah["juz"] = "" . $oldAyah["juz"];

            $newAyah["originalText"] = $localAyah["OrignalArabicText"];
            $newAyah["arabicText"] = $localAyah["ArabicText"];
            $newAyah["surahNo"] = $localAyah["SurahNo"];
            $newAyah["arabicLetterCount"] = $localAyah["ArabicLetterCount"];
            $newAyah["arabicWordCount"] = $localAyah["ArabicWordCount"];
            if($oldAyah["juz"] > $currentJuz) {
                echo "juz $currentJuz is over\n";
                $allJuzData[$currentJuz++] = $juzAyahs;
                $juzAyahs = [];
            }   
            if($page > $currentPage) {
                $juzAyahs[$currentPage++] = $pageAyahs;
                $pageAyahs = [];
            } 

            $pageAyahs[] = $newAyah;
        }
    } else {
        echo "Error fetching data for surah $surahNumber\n";
    }
}

$juzAyahs[$currentPage] = $pageAyahs;

echo "juz $currentJuz is over\n";
$allJuzData[$currentJuz] = $juzAyahs;

$jsonData = json_encode($allJuzData, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
$file = 'juz_data.json';
file_put_contents($file, $jsonData);
echo "Surah data with additional properties saved to $file\n";
