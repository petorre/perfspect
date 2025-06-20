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
?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available perfspect report Files</title>
</head>
<body>
    <h1>Available perfspect report .txt and .json Files</h1>

    <?php if (empty($files)): ?>
        <p>No files found.</p>
    <?php else: ?>
        <ul>
            <?php foreach ($files as $file): ?>
                <li>
                    <a href="<?= htmlspecialchars($file) ?>" download><?= htmlspecialchars($file) ?></a>
                </li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>
</body>
</html>
