package com.genesis.utils;

import hudson.Plugin;

public class GenesisUtilsPlugin extends Plugin {

    @Override
    public void start() throws Exception {
        super.start();
        System.out.println("Genesis Utils Plugin loaded");
    }

}