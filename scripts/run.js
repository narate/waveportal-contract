async function main() {
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther('0.1')
    });

    await waveContract.deployed();
    console.log(`Contract deployed to: ${waveContract.address}`);

    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(`Contract balance = ${hre.ethers.utils.formatEther(contractBalance)}`);

    let count = await waveContract.getTotalWaves();
    console.log(`Wave count = ${count.toNumber()}`);

    let waveTxn = await waveContract.wave('A message #1!');
    await waveTxn.wait();

    waveTxn = await waveContract.wave('A message #2!');
    await waveTxn.wait();

    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(`Contract balance = ${hre.ethers.utils.formatEther(contractBalance)}`);

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);
}

main()
    .then(() => process.exit(0))
    .catch((error => {
        console.log(error);
        process.exit(1);
    }))
