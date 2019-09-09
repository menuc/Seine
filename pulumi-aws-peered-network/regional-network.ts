import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

interface RegionalNetworkArgs {
    vpcCidr: pulumi.Input<string>;
    project: string;
}

export class RegionalNetwork extends pulumi.ComponentResource {
    readonly vpc: aws.ec2.Vpc;
    readonly subnet: aws.ec2.Subnet;
    readonly routeTable: aws.ec2.RouteTable;

    constructor(name: string, args: RegionalNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:AWSRegionalNetwork", name, {}, opts);
    }
}