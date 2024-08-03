// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {DeployDSC} from "script/DeployDSC.s.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Handler} from "./Handler.t.sol";

contract Invariants is StdInvariant, Test {
    DeployDSC deployer;
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    HelperConfig config;
    address weth;
    address wbtc;
    Handler handler;

    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (,, weth, wbtc,) = config.activeNetworkConfig();
        handler = new Handler(dsce, dsc);
        targetContract(address(handler));
    }

    function invariant_protocolMustHaveMoreCollateralValueThanTotalSupply() public view {
        uint256 totalDscSupply = dsc.totalSupply();
        uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dsce));
        uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(dsce));

        uint256 totalDepositedWethValue = dsce.getUsdValue(weth, totalWethDeposited);
        uint256 totalDepositedWbtcValue = dsce.getUsdValue(wbtc, totalWbtcDeposited);

        console.log("totalDscSupply: ", totalDscSupply);
        console.log("totalDepositedWethValue: ", totalDepositedWethValue);
        console.log("totalDepositedWbtcValue: ", totalDepositedWbtcValue);
        console.log("Times mint is called: ", handler.timesMintIsCalled());

        assert(totalDepositedWethValue + totalDepositedWbtcValue >= totalDscSupply);
    }

    function invariant_gettersShouldNotRevert() public view {
        dsce.getCollateralTokens();
        dsce.getDsc();
        dsce.getLiquidationBonus();
        dsce.getLiquidationThreshold();
        dsce.getMinHealthFactor();
        dsce.getPrecision();
        // dsce.getAccountCollateralValue();
        // dsce.getAccountInformation();
        // dsce.getCollateralBalaneOfUser();
        // dsce.getCollateralTokenPriceFeed();
        // dsce.getTokenAmountFromUsd();
        // dsce.getUsdValue();
        // dsce.getHealthFactor();
    }
}
