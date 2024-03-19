function revealQRCode(imageName) {
    var qrCode = document.querySelector('.qr-codes img[src="qr-codes/' + imageName + '.png"]');
    if (qrCode.style.display === "none" || qrCode.style.display === "") {
        qrCode.style.display = "block"; // Show the QR code if it's hidden
    } else {
        qrCode.style.display = "none"; // Hide the QR code if it's visible
    }
}
