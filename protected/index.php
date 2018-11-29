<html> 
<head> 
<title>hello</title> 
</head> 
<body> 
<h1> 
Hello, <?php echo($_SERVER['REMOTE_USER']) ?>! 
</h1> 

<?php
  $hdrs = apache_request_headers();
  if ( array_key_exists('OIDC_CLAIM_picture', $hdrs) ) {
        echo '<img src="' . $hdrs['OIDC_CLAIM_picture'] . '" style="max-height: 150px; max-width: 150px;"/>';
  }
?>

Headers:
<pre>
<?php print_r(array_map("htmlentities", apache_request_headers())); ?>
</pre>

Environment variables:
<pre>
<?php print_r(array_map("htmlentities", $_SERVER)); ?>
</pre>

<a href="/protected/redirect_uri?logout=">Logout</a>

</body> 
</html> 
