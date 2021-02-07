/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';
const { Wallets } = require('fabric-network');
const FabricCAServices = require('fabric-ca-client');
const path = require('path');
const { buildCAClient, enrollAdmin } = require('./CAUtil.js');
const { buildCCPOrg1, buildCCPOrg5, buildCCPOrg6, buildWallet } = require('./AppUtil.js');
const walletPath = path.join(__dirname, 'wallet');

let ccp = null;
let caClientHostName = '';
let mspOrg = '';
let adminUserId = '';
exports.registerAdmin = async function(orgId, adminUserId, adminUserPasswd) {
    try {

        switch(orgId){
            case 1:
                ccp = buildCCPOrg1();
                caClientHostName = 'ca.org1.example.com';
                mspOrg = 'Org1MSP';
                break;
            
            case 5:
                ccp = buildCCPOrg5();
                caClientHostName = 'ca.org5.example.com';
                mspOrg = 'Org5MSP';
                break;
            
            case 6:
                ccp = buildCCPOrg6();
                caClientHostName = 'ca.org6.example.com';
                mspOrg = 'Org6MSP';
                break;
            
            default:
                return;
        }

		const caClient = buildCAClient(FabricCAServices, ccp, caClientHostName);
		const wallet = await buildWallet(Wallets, walletPath);
        await enrollAdmin(caClient, wallet, mspOrg, adminUserId, adminUserPasswd);
    }
    catch (error) {
		console.error(`${error}`);
    }
}