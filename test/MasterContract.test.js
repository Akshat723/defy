// MasterContract.test.js
// SPDX-License-Identifier: MIT
const MasterContract = artifacts.require('MasterContract');

contract('MasterContract', (accounts) => {
    let masterContract;
    const owner = accounts[0];
    const user = accounts[1];

    beforeEach(async () => {
        masterContract = await MasterContract.new({ from: owner });
    });

    it('should allow owner to deposit', async () => {
        const depositAmount = web3.utils.toWei('1', 'ether');
        await masterContract.deposit({ from: owner, value: depositAmount });
        const userBalance = await masterContract.balances(owner);
        assert.equal(userBalance.toString(), depositAmount, 'Incorrect user balance after deposit');
    });

    it('should allow owner to approve gas funds', async () => {
        const gasFundsAmount = web3.utils.toWei('0.5', 'ether');
        await masterContract.deposit({ from: owner, value: gasFundsAmount });
        await masterContract.approveGasFunds(masterContract.address, gasFundsAmount, { from: owner });
        const masterBalance = await masterContract.balances(masterContract.address);
        assert.equal(masterBalance.toString(), '0', 'Incorrect master contract balance after gas funds approval');
    });

    it('should not allow non-owner to approve gas funds', async () => {
        const gasFundsAmount = web3.utils.toWei('0.5', 'ether');
        await masterContract.deposit({ from: owner, value: gasFundsAmount });

        try {
            await masterContract.approveGasFunds(masterContract.address, gasFundsAmount, { from: user });
            assert.fail('Expected an error');
        } catch (error) {
            assert.include(error.message, 'Not the owner', 'Incorrect error message');
        }
    });
});
