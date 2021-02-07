/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';
const { Wallets } = require('fabric-network');
const FabricCAServices = require('fabric-ca-client');
const path = require('path');
const { buildCAClient, registerAndEnrollUser } = require('./CAUtil.js');
const { buildCCPOrg1, buildCCPOrg5, buildCCPOrg6, buildWallet } = require('./AppUtil.js');
const walletPath = path.join(__dirname, 'wallet');

let ccp = null;
let caClientHostName = '';
let orgDept = '';
let mspOrg = '';
exports.registerUser = async function(orgUserId, orgId, adminUserId) {
    try {

        switch(orgId){
            case 1:
                ccp = buildCCPOrg1;
                caClientHostName = 'ca.org1.example.com';
                orgDept = 'org1.department1';
                mspOrg = 'Org1MSP';
                break;
            
            case 5:
                ccp = buildCCPOrg5;
                caClientHostName = 'ca.org5.example.com';
                orgDept = 'org5.department1';
                mspOrg = 'Org5MSP';
                break;
            
            case 6:
                ccp = buildCCPOrg6;
                caClientHostName = 'ca.org6.example.com';
                orgDept = 'org6.department1';
                mspOrg = 'Org6MSP';
                break;
            
            default:
                return;
        }

		const caClient = buildCAClient(FabricCAServices, ccp, caClientHostName);
		const wallet = await buildWallet(Wallets, walletPath);
        await registerAndEnrollUser(caClient, wallet, mspOrg, orgUserId, adminUserId, orgDept);
    }
    catch (error) {
		console.error(`${error}`);
    }
}