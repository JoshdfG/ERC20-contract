import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Erc20", async () => {
  let Erc20: any;
  let erc: any;
  const [account1, account2] = await ethers.getSigners();

  Erc20 = await ethers.getContractFactory("Lock");
  erc = await Erc20.deploy(account1.address);

  return { erc, account1, account2 };
});
// 
// )
