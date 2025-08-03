const { expect } = require("chai");

describe("BarleyHarvestTracker", function () {
  let contract, owner, farmer, maltster, exporter, brewery;

  beforeEach(async () => {
    [owner, farmer, maltster, exporter, brewery] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory("BarleyHarvestTracker");
    contract = await Factory.deploy(farmer.address, maltster.address, exporter.address, brewery.address);
    await contract.waitForDeployment();
  });

  it("Allows farmer to add a sensor reading", async () => {
    await contract.connect(farmer).addSensorReading(85, 1234, 200, Math.floor(Date.now() / 1000 + 86400));
    const reading = await contract.readings(0);
    expect(reading.soilMoisture).to.equal(1234);
  });

  it("Prevents non-farmer from adding readings", async () => {
    await expect(
      contract.connect(maltster).addSensorReading(85, 1100, 180, Math.floor(Date.now() / 1000 + 86400))
    ).to.be.revertedWith("Only farmer");
  });
});
