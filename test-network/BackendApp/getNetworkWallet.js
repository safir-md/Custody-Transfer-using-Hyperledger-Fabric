'use strict';

const { Wallets } = require('fabric-network');
const path = require('path');

const { buildWallet } = require('./AppUtil.js');
const { registerUser } = require('./registerUser.js');
const { registerAdmin } = require('./registerAdmin.js');

const walletPath = path.join(__dirname, 'wallet');

exports.getNetworkWallet = async function() {
    try {
        //Create Wallet
        const wallet = await buildWallet(Wallets, walletPath);
        //Create Users and Admins
        const orgs = [1,5,6];
        const users = ['buyer_user','tsp_user','seller_user'];
        for (var ctr = 0; ctr < 3; ctr++) {
            await registerAdmin(orgs[ctr], 'admin'+orgs[ctr], 'adminpw'+orgs[ctr]);
            await registerUser(users[ctr], orgs[ctr], 'admin'+orgs[ctr]);
        }

        return wallet;
        
    } catch (error) {
        console.error(`${error}`);
    }
    
}