const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Shakti", function () {
  it("Get notes should fail if wallet is not being used", async function () {
    const Shakti = await ethers.getContractFactory("Shakti");
    const shaktiContract = await Shakti.deploy();
    await shaktiContract.deployed();

    await expect(shaktiContract.getNotes()).to.be.revertedWith("User don't have any notes")
  });

  it("New Note emit", async function () {
    const Shakti = await ethers.getContractFactory("Shakti");
    const shaktiContract = await Shakti.deploy();
    await shaktiContract.deployed();
    const tx = shaktiContract.createNote(
      "abc",
      "123"
    )
    await expect(tx).to.emit(Shakti, 'NewNote')

    expect(await shaktiContract.getNotes()).is.an('Array')
  });

  it("Make Note Public", async function () {
    const Shakti = await ethers.getContractFactory("Shakti");
    const shaktiContract = await Shakti.deploy();
    await shaktiContract.deployed();

    const tx1 = shaktiContract.createNote(
      "abc",
      "123"
    )
    await expect(tx1).to.emit(Shakti, 'NewNote')

    const tx = shaktiContract.makeNotePublic(
      0,
      "123"
    )
    await expect(tx).to.emit(Shakti, 'PublicNote')
  });
});
