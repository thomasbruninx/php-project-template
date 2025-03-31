<?php

$DB_HOST = getenv('DB_HOST') ? getenv('DB_HOST') : 'localhost';
$DB_PORT = getenv('DB_PORT') ? getenv('DB_PORT') : '3306';
$DB_NAME = getenv('DB_NAME') ? getenv('DB_NAME') : '';
$DB_USERNAME = getenv('DB_USERNAME') ? getenv('DB_USERNAME') : '';
$DB_PASSWORD = getenv('DB_PASSWORD') ? getenv('DB_PASSWORD') : '';

echo '<h1>Thomas&apos; PHP project template</h1>';
echo '<p>Hello World!</p>';

echo 'Database at '.$DB_HOST.':'.$DB_PORT;
$DB_CONNECTION = false;
try {
    $DB_CONNECTION = new mysqli($DB_HOST.':'.$DB_PORT, $DB_USERNAME, $DB_PASSWORD, $DB_NAME);
} catch (Exception $ex) {
    echo '<p>Database connection: failed (' . $ex->getMessage() . ')</p>';
}
if ($DB_CONNECTION) echo '<p>Database connection: OK</p>';

phpinfo();