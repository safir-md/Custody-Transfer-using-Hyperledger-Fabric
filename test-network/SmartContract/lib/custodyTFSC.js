/*
 SPDX-License-Identifier: Apache-2.0
*/

'use strict';

const {Contract} = require('fabric-contract-api');

class Chaincode extends Contract {

	async ReadAsset(ctx, id) {
		const assetJSON = await ctx.stub.getState(id); // get the asset from chaincode state
		if (!assetJSON || assetJSON.length === 0) {
			throw new Error(`Asset ${id} does not exist`);
		}

		return assetJSON.toString();
	}

	async GetAssetHistory(ctx, assetName) {

        let resultsIterator = await ctx.stub.getHistoryForKey(assetName);
		let results = await this.GetAllResults(resultsIterator, true);

		return JSON.stringify(results);
	}
	
	async GetBlockedQty(ctx) {
		let assetJSON = await ctx.stub.getState('CrudeOil');
		assetJSON = JSON.parse(assetJSON.toString());
		return parseInt(assetJSON.blockedQuantity);
	}

	async ReloadSellerQty(ctx, id, qty) {
		const exists = await this.AssetExists(ctx, id);
        if (!exists) {
            throw new Error(`The asset ${id} does not exist`);
        }
        let assetJSON = await ctx.stub.getState(id);
        assetJSON = JSON.parse(assetJSON.toString());
        // overwriting original asset with new asset
        const updatedAsset = {
            assetID: id,
            rate: assetJSON.rate,
            buyerCountry: assetJSON.buyerCountry,
            buyerVolume: assetJSON.buyerVolume,
            sellerCountry: assetJSON.sellerCountry,
			sellerVolume: parseInt(assetJSON.sellerVolume)+parseInt(qty),
			location: assetJSON.location,
			blockedQuantity: assetJSON.blockedQuantity,
			globalMSSBuyer: assetJSON.globalMSSBuyer,
			nationalMSSBuyer: assetJSON.nationalMSSBuyer,
			globalMSSSeller: assetJSON.globalMSSSeller,
			nationalMSSSeller: assetJSON.nationalMSSSeller

        };
        return ctx.stub.putState(id, Buffer.from(JSON.stringify(updatedAsset)));
	}

	async UpdateAssetLocation(ctx, id, location) {
        const exists = await this.AssetExists(ctx, id);
        if (!exists) {
            throw new Error(`The asset ${id} does not exist`);
        }
        let assetJSON = await ctx.stub.getState(id);
		assetJSON = JSON.parse(assetJSON.toString());
		let buyerVol = parseInt(assetJSON.buyerVolume);
		let blockQty = parseInt(assetJSON.blockedQuantity);
		if (location == 'Germany' && blockQty>0) {
			buyerVol = buyerVol + blockQty;
			blockQty = 0;
		}
        // overwriting original asset with new asset
        const updatedAsset = {
            assetID: id,
            rate: assetJSON.rate,
			buyerCountry: assetJSON.buyerCountry,
            buyerVolume: buyerVol,
            sellerCountry: assetJSON.sellerCountry,
			sellerVolume: assetJSON.sellerVolume,
			location: location,
			blockedQuantity: blockQty,
			globalMSSBuyer: assetJSON.globalMSSBuyer,
			nationalMSSBuyer: assetJSON.nationalMSSBuyer,
			globalMSSSeller: assetJSON.globalMSSSeller,
			nationalMSSSeller: assetJSON.nationalMSSSeller

        };
        return ctx.stub.putState(id, Buffer.from(JSON.stringify(updatedAsset)));
	}

	async UpdateAsset(ctx, qty, global_crt, national_crt) {
		let assetJSON = await ctx.stub.getState('CrudeOil');
		assetJSON = JSON.parse(assetJSON.toString());
		let sellerVol = parseInt(assetJSON.sellerVolume);
		if (qty>sellerVol) {
			return "Sorry. Seller doesn't possess "+qty+" Gallons Oil";
		}
		const updatedAsset = {
            assetID: 'CrudeOil',
            rate: assetJSON.rate,
            buyerCountry: assetJSON.buyerCountry,
            buyerVolume: assetJSON.buyerVolume,
            sellerCountry: assetJSON.sellerCountry,
			sellerVolume: parseInt(assetJSON.sellerVolume)-parseInt(qty),
			location: assetJSON.location,
			blockedQuantity: qty,
			globalMSSBuyer: global_crt,
			nationalMSSBuyer: national_crt,
			globalMSSSeller: assetJSON.globalMSSSeller,
			nationalMSSSeller: assetJSON.nationalMSSSeller

        };
        return ctx.stub.putState(id, Buffer.from(JSON.stringify(updatedAsset)));
	}

	async InitLedger(ctx) {
		const assets = [
			{
				assetID: 'CrudeOil',
                rate: 2.57,
                buyerCountry: 'Germany',
                buyerVolume: 0,
                sellerCountry: 'USA',
                sellerVolume: 10000,
				location: 'USA',
				blockedQuantity: 0,
				globalMSSBuyer: 'ISO 8222 Standard',
				nationalMSSBuyer: 'Physikalisch-Technische Bundesanstalt (PTB) Standard',
				globalMSSSeller: 'American Petroleum Institute (API) Standard',
				nationalMSSSeller: 'American Petroleum Institute (API) Standard'
			}
		];

		for (const asset of assets) {
			await this.CreateAsset(
				ctx,
				asset.assetID,
				asset.rate,
				asset.buyerCountry,
				asset.buyerVolume,
                asset.sellerCountry,
                asset.sellerVolume,
				asset.location,
				asset.blockedQuantity,
				asset.globalMSSBuyer,
				asset.nationalMSSBuyer,
				asset.globalMSSSeller,
				asset.nationalMSSSeller
			);
		}
	}

	async CreateAsset(ctx, assetID, rate, buyerCountry, buyerVolume, sellerCountry, sellerVolume, location, blockedQuantity, globalMSSBuyer, nationalMSSBuyer, globalMSSSeller, nationalMSSSeller) {
		const exists = await this.AssetExists(ctx, assetID);
		if (exists) {
			throw new Error(`The asset ${assetID} already exists`);
		}

		// ==== Create asset object and marshal to JSON ====
		let asset = {
			docType: 'asset',
			assetID: assetID,
            rate: rate,
            buyerCountry: buyerCountry,
            buyerVolume: buyerVolume,
            sellerCountry: sellerCountry,
			sellerVolume: sellerVolume,
			location: location,
			blockedQuantity: blockedQuantity,
			globalMSSBuyer: globalMSSBuyer,
			nationalMSSBuyer: nationalMSSBuyer,
			globalMSSSeller: globalMSSSeller,
			nationalMSSSeller: nationalMSSSeller
		};


		// === Save asset to state ===
		await ctx.stub.putState(assetID, Buffer.from(JSON.stringify(asset)));
		let indexName = 'sellerCountry~name';
		let sellerCountryNameIndexKey = await ctx.stub.createCompositeKey(indexName, [asset.sellerCountry, asset.assetID]);

		//  Save index entry to state. Only the key name is needed, no need to store a duplicate copy of the marble.
		//  Note - passing a 'nil' value will effectively delete the key from state, therefore we pass null character as value
		await ctx.stub.putState(sellerCountryNameIndexKey, Buffer.from('\u0000'));
	}

	async GetAllResults(iterator, isHistory) {
		let allResults = [];
		let res = await iterator.next();
		while (!res.done) {
			if (res.value && res.value.value.toString()) {
				let jsonRes = {};
				console.log(res.value.value.toString('utf8'));
				if (isHistory && isHistory === true) {
					jsonRes.TxId = res.value.tx_id;
					jsonRes.Timestamp = res.value.timestamp;
					try {
						jsonRes.Value = JSON.parse(res.value.value.toString('utf8'));
					} catch (err) {
						console.log(err);
						jsonRes.Value = res.value.value.toString('utf8');
					}
				} else {
					jsonRes.Key = res.value.key;
					try {
						jsonRes.Record = JSON.parse(res.value.value.toString('utf8'));
					} catch (err) {
						console.log(err);
						jsonRes.Record = res.value.value.toString('utf8');
					}
				}
				allResults.push(jsonRes);
			}
			res = await iterator.next();
		}
		iterator.close();
		return allResults;
	}

	// FUTURE SCOPE METHODS :--->

	async QueryAssetsByBuyer(ctx, buyer) {
		let queryString = {};
		queryString.selector = {};
		queryString.selector.docType = 'asset';
		queryString.selector.buyerCountry = buyer;
		return await this.GetQueryResultForQueryString(ctx, JSON.stringify(queryString)); //shim.success(queryResults);
    }
    
    async QueryAssetsBySeller(ctx, seller) {
		let queryString = {};
		queryString.selector = {};
		queryString.selector.docType = 'asset';
		queryString.selector.sellerCountry = seller;
		return await this.GetQueryResultForQueryString(ctx, JSON.stringify(queryString)); //shim.success(queryResults);
	}

	async GetAllAssets(ctx) {
        const allResults = [];
        // range query with empty string for startKey and endKey does an open-ended query of all assets in the chaincode namespace.
        const iterator = await ctx.stub.getStateByRange('', '');
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ Key: result.value.key, Record: record });
            result = await iterator.next();
        }
        return JSON.stringify(allResults);
	}
	
	async AssetExists(ctx, assetName) {
		let assetState = await ctx.stub.getState(assetName);
		return assetState && assetState.length > 0;
	}

	async QueryAssets(ctx, queryString) {
		return await this.GetQueryResultForQueryString(ctx, queryString);
	}
}

module.exports = Chaincode;
