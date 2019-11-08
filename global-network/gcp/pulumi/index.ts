import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

interface GCPGlobalNetworkArgs {
    subnets: {[key: string]: {region: string, cidr: string}};
    firewalls?: {[key: string]: Omit<gcp.compute.FirewallArgs, "network">};
}

export class GCPGlobalNetwork extends pulumi.ComponentResource {
    readonly network: gcp.compute.Network;
    readonly firewalls: {[key: string]: gcp.compute.Firewall};
    readonly subnets: {[key: string]: gcp.compute.Subnetwork};

    constructor(name: string, args: GCPGlobalNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:GCP:GlobalNetwork", name, {}, opts);

        this.network = new gcp.compute.Network(name, {
            autoCreateSubnetworks: false,
            routingMode: "GLOBAL",
        }, {
            parent: this,
        });

        this.subnets = {};
        for (let subnetName in args.subnets) {
            this.subnets[subnetName] = new gcp.compute.Subnetwork(subnetName, {
                network: this.network.id,
                region: args.subnets[subnetName].region,
                ipCidrRange: args.subnets[subnetName].cidr,
            }, {
                parent: this,
            });
        }
    }
}
