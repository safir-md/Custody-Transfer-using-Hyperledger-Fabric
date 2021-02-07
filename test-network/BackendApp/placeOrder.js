/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';
function prettyJSONString(inputString) {
	return JSON.stringify(JSON.parse(inputString), null, 2);
}
exports.placeOrder = async function(contract, qty, global_crt, national_crt) {
    try {
        if (global_crt!="ISO" || national_crt!="PTB") {
            return "Sorry, Your measurement standards doesn't match ISO and PTB!";
        }
        let result = await contract.submitTransaction('UpdateAsset', qty, global_crt, national_crt);

        return prettyJSONString(result.toString());

    } catch (error) {
        console.error(`${error}`);
    }
}