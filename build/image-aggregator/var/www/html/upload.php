<?php
// Check that the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if required fields are present
    if (isset($_POST['filename']) && isset($_POST['content'])) {
        $filename = basename($_POST['filename']); // Prevent directory traversal
        $base64Content = $_POST['content'];

        // Decode base64 content
        $decodedContent = base64_decode($base64Content, true);

        if ($decodedContent === false) {
            http_response_code(400);
            echo "Invalid base64 content.";
            exit;
        }

        // Save file to local filesystem
        $filePath = __DIR__ . '/' . $filename;

        if (file_put_contents($filePath, $decodedContent) !== false) {
            echo "File saved successfully as $filename.";
        } else {
            http_response_code(500);
            echo "Failed to write file.";
        }
    } else {
        http_response_code(400);
        echo "Missing filename or content.";
    }
} else {
    http_response_code(405);
    echo "Only POST requests are allowed.";
}
?>
