<?php

$all_juz_data = file_get_contents('juz_data.json');
$all_juz_data_json = json_decode($all_juz_data, true, 512, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
$current_page = 0;
for ($juz = 1; $juz <= 30; $juz++) {
    $juz_data = $all_juz_data_json["$juz"];
    foreach ($juz_data as $page) {
        $all_page_data[$current_page++] = $page;
    }
    echo "$juz. juz is over\n";
}

$jsonData = json_encode($all_page_data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
$file = 'page_data.json';
file_put_contents($file, $jsonData);
echo "Surah data with additional properties saved to $file\n";
