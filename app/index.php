<html>
<head>
<style>
body {
  background-color: #008000;
}
</style>
    <h2>LEMP Stack Test</h2>
</head>
    <body>
    <p>You are running PHP version <?= phpversion() ?></p>
    <?php echo '<p>Hello Dev</p>';

	$ip = $_SERVER['REMOTE_ADDR'];
	echo "<h2>Client IP Information</h2>";
	echo "Your IP address : " . $ip;
	echo "<br>Your hostname : ". gethostbyaddr($ip) ;

    ?>
</body>
</html>
