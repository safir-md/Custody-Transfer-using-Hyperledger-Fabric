/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';
function prettyJSONString(inputString) {
	return JSON.stringify(JSON.parse(inputString), null, 2);
}
exports.getBlockedQty = async function(contract) {
    let result = await contract.evaluateTransaction('GetBlockedQty');
    return prettyJSONString(result.toString());
}