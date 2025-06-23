<?php
$allowed_extensions = ['txt', 'json'];
$files = [];

foreach ($allowed_extensions as $ext) {
    foreach (glob("*.$ext") as $file) {
        if (is_file($file)) {
            $files[] = $file;
        }
    }
}

// Detect if client is curl or CLI
$user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
$is_curl = preg_match('/curl|wget|httpie|http-client/i', $user_agent);

// Plain text response for CLI clients
if ($is_curl) {
    header('Content-Type: text/plain');
    foreach ($files as $file) {
        echo $file . "\n";
    }
    exit;
}

// Otherwise, return HTML view
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Files</title>
</head>
<body>
    <h1>Available .txt and .json Files</h1>

    <?php if (empty($files)): ?>
        <p>No files found.</p>
    <?php else: ?>
        <ul>
            <?php foreach ($files as $file): ?>
                <li><a href="<?= htmlspecialchars($file) ?>" download><?= htmlspecialchars($file) ?></a></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>
</body>
</html>
