/*
 * SPDX-License-Identifier: Apache-2.0
 */
package org.example;

import org.hyperledger.fabric.contract.Context;
import org.hyperledger.fabric.contract.ContractInterface;
import org.hyperledger.fabric.contract.annotation.Contract;
import org.hyperledger.fabric.contract.annotation.Default;
import org.hyperledger.fabric.contract.annotation.Transaction;
import org.hyperledger.fabric.contract.annotation.Contact;
import org.hyperledger.fabric.contract.annotation.Info;
import org.hyperledger.fabric.contract.annotation.License;
import static java.nio.charset.StandardCharsets.UTF_8;

@Contract(name = "CommodityContract",
    info = @Info(title = "Commodity contract",
                description = "My Smart Contract",
                version = "0.0.1",
                license =
                        @License(name = "Apache-2.0",
                                url = ""),
                                contact =  @Contact(email = "Custody-Transfer-using-Hyperledger-Fabric@example.com",
                                                name = "Custody-Transfer-using-Hyperledger-Fabric",
                                                url = "http://Custody-Transfer-using-Hyperledger-Fabric.me")))
@Default
public class CommodityContract implements ContractInterface {
    public  CommodityContract() {

    }
    @Transaction()
    public boolean commodityExists(Context ctx, String commodityId) {
        byte[] buffer = ctx.getStub().getState(commodityId);
        return (buffer != null && buffer.length > 0);
    }

    @Transaction()
    public void createCommodity(Context ctx, String commodityId, String value) {
        boolean exists = commodityExists(ctx,commodityId);
        if (exists) {
            throw new RuntimeException("The asset "+commodityId+" already exists");
        }
        Commodity asset = new Commodity();
        asset.setValue(value);
        ctx.getStub().putState(commodityId, asset.toJSONString().getBytes(UTF_8));
    }

    @Transaction()
    public Commodity readCommodity(Context ctx, String commodityId) {
        boolean exists = commodityExists(ctx,commodityId);
        if (!exists) {
            throw new RuntimeException("The asset "+commodityId+" does not exist");
        }

        Commodity newAsset = Commodity.fromJSONString(new String(ctx.getStub().getState(commodityId),UTF_8));
        return newAsset;
    }

    @Transaction()
    public void updateCommodity(Context ctx, String commodityId, String newValue) {
        boolean exists = commodityExists(ctx,commodityId);
        if (!exists) {
            throw new RuntimeException("The asset "+commodityId+" does not exist");
        }
        Commodity asset = new Commodity();
        asset.setValue(newValue);

        ctx.getStub().putState(commodityId, asset.toJSONString().getBytes(UTF_8));
    }

    @Transaction()
    public void deleteCommodity(Context ctx, String commodityId) {
        boolean exists = commodityExists(ctx,commodityId);
        if (!exists) {
            throw new RuntimeException("The asset "+commodityId+" does not exist");
        }
        ctx.getStub().delState(commodityId);
    }

}
