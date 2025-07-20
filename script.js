async function connectMetaMask() {
    if (typeof window.ethereum !== 'undefined') {
        try {
            // Request connection to MetaMask
            await window.ethereum.request({ method: 'eth_requestAccounts' });
            const web3 = new Web3(window.ethereum);

            // Get user's wallet address
            const accounts = await web3.eth.getAccounts();
            const userAddress = accounts[0];

            // Calculate total price (0.01 ETH per ticket)
            const ticketCount = document.getElementById('ticket-count').value;
            const ticketPrice = 0.01; // ETH
            const totalPrice = ticketCount * ticketPrice;

            // Send transaction
            await web3.eth.sendTransaction({
                from: userAddress,
                to: 'YOUR_WALLET_ADDRESS', // Replace with your wallet address
                value: web3.utils.toWei(totalPrice.toString(), 'ether'),
                gas: 21000
            });

            alert('Payment successful! Your ticket has been registered.');
        } catch (error) {
            console.error(error);
            alert('Payment failed. Please try again.');
        }
    } else {
        alert('Please install MetaMask.');
    }
}