const main = async () => {
        const NFTContactFactory = await hre.ethers.getContractFactory('MyEpicNFT');
        const NFTContract = await NFTContactFactory.deploy();
        await NFTContract.deployed();
        console.log('Contract deployed to:', NFTContract.address);

        const count = await NFTContract.getCurrentTokenId();
        console.log(count);

        // Call the function 51 times and see if it works.

        for (let i = 0; i <= 10; i++) {
                const mintTxn = await NFTContract.makeAnEpicNFT();
                // wait for the NFT to be minted
                await mintTxn.wait();
                console.log('Mint success for number', i);
        }
};

const runMain = async () => {
        try {
                await main();
                process.exit(0);
        } catch (error) {
                console.log(error);
                process.exit(1);
        }
};

runMain();
