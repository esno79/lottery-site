
// اتصال به متامسک و دریافت آدرس کیف پول
async function connectWallet() {
    if (window.ethereum) {
        try {
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            const walletAddress = accounts[0];
            document.getElementById('wallet-address').textContent = walletAddress;
            console.log("Connected wallet:", walletAddress);
        } catch (error) {
            console.error("User rejected the connection", error);
        }
    } else {
        alert("MetaMask is not installed. Please install it to use this feature.");
    }
}

// بارگذاری خودکار در صورت اتصال قبلی
window.addEventListener('load', async () => {
    if (window.ethereum && window.ethereum.selectedAddress) {
        document.getElementById('wallet-address').textContent = window.ethereum.selectedAddress;
    }
});
