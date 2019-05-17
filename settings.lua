data:extend({
    -- Server text settings.
    {
        type = "string-setting",
        name = "oarc-welcome-title",
        setting_type = "runtime-global",
        default_value = "[INSERT SERVER WELCOME TITLE!]",
        order = "aaa"
    },
    {
        type = "string-setting",
        name = "oarc-welcome-msg",
        setting_type = "runtime-global",
        default_value = "[INSERT SERVER WELCOME MSG!]",
        order = "aab"
    },
    {
        type = "string-setting",
        name = "oarc-server-rules",
        setting_type = "runtime-global",
        default_value = "Rules: Be polite. Ask before changing other players's stuff. Have fun!\nThis server is running a custom scenario that allows individual starting areas on the map.",
        order = "aac"
    },
    {
        type = "string-setting",
        name = "oarc-server-contact",
        setting_type = "runtime-global",
        default_value = "Contact: SteamID:Oarc | oarcinae@gmail.com | discord.gg/trnpcen",
        order = "aad"
    },

    -- Core game settings.
    {
        type = "bool-setting",
        name = "oarc-enable-vanilla-spawns",
        setting_type = "runtime-global",
        default_value = false,
        order = "baa"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-buddy-spawn",
        setting_type = "runtime-global",
        default_value = true,
        order = "bab"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-shared-team-vision",
        setting_type = "runtime-global",
        default_value = true,
        order = "bac"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-regrowth",
        setting_type = "runtime-global",
        default_value = false,
        order = "bad"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-abandoned-base-removal",
        setting_type = "runtime-global",
        default_value = true,
        order = "bae"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-research-queue",
        setting_type = "runtime-global",
        default_value = true,
        order = "baf"
    },
    {
        type = "bool-setting",
        name = "oarc-modified-enemy-spawning",
        setting_type = "runtime-global",
        default_value = true,
        order = "bag"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-separate-teams",
        setting_type = "runtime-global",
        default_value = true,
        order = "bah"
    },
    {
        type = "string-setting",
        name = "oarc-main-force",
        setting_type = "runtime-global",
        default_value = "Main Force",
        order = "bai"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-shared-spawns",
        setting_type = "runtime-global",
        default_value = true,
        order = "baj"
    },
    {
        type = "int-setting",
        name = "oarc-max-players-shared-spawn",
        setting_type = "runtime-global",
        default_value = 0,
        minimum_value = 0,
        order = "bak"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-shared-chat",
        setting_type = "runtime-global",
        default_value = true,
        order = "bal"
    },
    {
        type = "bool-setting",
        name = "oarc-allow-moat-choice",
        setting_type = "runtime-global",
        default_value = true,
        order = "bam"
    },
    {
        type = "int-setting",
        name = "oarc-moat-size-mod",
        setting_type = "runtime-global",
        default_value = 1,
        minimum_value = 0,
        order = "ban"
    },

    -- Frontier silo stuff
    {
        type = "bool-setting",
        name = "oarc-frontier-rocket-silo",
        setting_type = "runtime-global",
        default_value = false,
        order = "bba"
    },
    {
        type = "bool-setting",
        name = "oarc-silo-islands",
        setting_type = "runtime-global",
        default_value = false,
        order = "bbb"
    },
    {
        type = "int-setting",
        name = "oarc-frontier-silo-count",
        setting_type = "runtime-global",
        default_value = 3,
        minimum_value = 0,
        order = "bbc"
    },
    {
        type = "int-setting",
        name = "oarc-frontier-silo-distance",
        setting_type = "runtime-global",
        default_value = 200,
        minimum_value = 10,
        order = "bbd"
    },
    {
        type = "bool-setting",
        name = "oarc-frontier-silo-vision",
        setting_type = "runtime-global",
        default_value = true,
        order = "bbe"
    },
    {
        type = "bool-setting",
        name = "oarc-frontier-silo-allow-build",
        setting_type = "runtime-global",
        default_value = true,
        order = "bbf"
    },


    -- Distance and size settings
    {
        type = "int-setting",
        name = "oarc-near-dist-start",
        setting_type = "runtime-global",
        default_value = 0,
        minimum_value = 0,
        order = "bca"
    },
    {
        type = "int-setting",
        name = "oarc-near-dist-end",
        setting_type = "runtime-global",
        default_value = 50,
        minimum_value = 50,
        order = "bcb"
    },
    {
        type = "int-setting",
        name = "oarc-far-dist-start",
        setting_type = "runtime-global",
        default_value = 200,
        minimum_value = 100,
        order = "bcc"
    },
    {
        type = "int-setting",
        name = "oarc-far-dist-end",
        setting_type = "runtime-global",
        default_value = 300,
        minimum_value = 150,
        order = "bcd"
    },
    {
        type = "int-setting",
        name = "oarc-enforce-land-area-tile-dist",
        setting_type = "runtime-global",
        default_value = 58,
        minimum_value = 32,
        order = "bce"
    },
    {
        type = "int-setting",
        name = "oarc-safe-area-chunk-dist",
        setting_type = "runtime-global",
        default_value = 256,
        minimum_value = 0,
        order = "bcf"
    },
    {
        type = "int-setting",
        name = "oarc-warning-area-chunk-dist",
        setting_type = "runtime-global",
        default_value = 512,
        minimum_value = 0,
        order = "bcg"
    },
    {
        type = "int-setting",
        name = "oarc-warning-area-reduction-ratio",
        setting_type = "runtime-global",
        default_value = 20,
        minimum_value = 0,
        order = "bch"
    },
    {
        type = "int-setting",
        name = "oarc-reduced-danger-area-chunk-dist",
        setting_type = "runtime-global",
        default_value = 1024,
        minimum_value = 0,
        order = "bci"
    },
    {
        type = "int-setting",
        name = "oarc-reduced-danger-area-reduction-ratio",
        setting_type = "runtime-global",
        default_value = 5,
        minimum_value = 0,
        order = "bcj"
    },


    -- Vanilla spawn count settings.
    {
        type = "int-setting",
        name = "oarc-vanilla-spawn-count",
        setting_type = "runtime-global",
        default_value = 100,
        minimum_value = 1,
        order = "bda"
    },
    {
        type = "int-setting",
        name = "oarc-vanilla-spawn-spacing",
        setting_type = "runtime-global",
        default_value = 2000,
        minimum_value = 500,
        order = "bdb"
    },



    -- Resource settings
    {
        type = "bool-setting",
        name = "oarc-resource-shape-circle",
        setting_type = "runtime-global",
        default_value = true,
        order = "bfa"
    },
    {
        type = "bool-setting",
        name = "oarc-force-grass",
        setting_type = "runtime-global",
        default_value = true,
        order = "bfb"
    },
    {
        type = "bool-setting",
        name = "oarc-tree-circle",
        setting_type = "runtime-global",
        default_value = true,
        order = "bfc"
    },
    {
        type = "bool-setting",
        name = "oarc-tree-octagon",
        setting_type = "runtime-global",
        default_value = false,
        order = "bfd"
    },

    -- Resource settings additional
    {
        type = "int-setting",
        name = "oarc-water-length",
        setting_type = "runtime-global",
        default_value = 8,
        minimum_value = 1,
        order = "bga"
    },
    {
        type = "int-setting",
        name = "oarc-water-x-offset",
        setting_type = "runtime-global",
        default_value = -4,
        order = "bgb"
    },
    {
        type = "int-setting",
        name = "oarc-water-y-offset",
        setting_type = "runtime-global",
        default_value = -48,
        order = "bgc"
    },

    {
        type = "bool-setting",
        name = "oarc-resource-rand-pos-enabled",
        setting_type = "runtime-global",
        default_value = true,
        order = "bgd"
    },
    {
        type = "int-setting",
        name = "oarc-resource-rand-pos-radius",
        setting_type = "runtime-global",
        default_value = 44,
        minimum_value = 1,
        order = "bge"
    },
    {
        type = "double-setting",
        name = "oarc-resource-rand-pos-angle-offset",
        setting_type = "runtime-global",
        default_value = 2.32,
        minimum_value = 0,
        maximum_value = 6.28,
        order = "bgf"
    },
    {
        type = "double-setting",
        name = "oarc-resource-rand-pos-angle-final",
        setting_type = "runtime-global",
        default_value = 4.46,
        minimum_value = 0,
        maximum_value = 6.28,
        order = "bgg"
    },

    -- Resource ore 1
    {
        type = "string-setting",
        name = "oarc-resource-1-name",
        setting_type = "runtime-global",
        default_value = "iron-ore",
        order = "bgh"
    },
    {
        type = "int-setting",
        name = "oarc-resource-1-amount",
        setting_type = "runtime-global",
        default_value = 1500,
        minimum_value = 0,
        order = "bgi"
    },    
    {
        type = "int-setting",
        name = "oarc-resource-1-size",
        setting_type = "runtime-global",
        default_value = 16,
        minimum_value = 0,
        order = "bgk"
    },

    -- Resource ore 2
    {
        type = "string-setting",
        name = "oarc-resource-2-name",
        setting_type = "runtime-global",
        default_value = "copper-ore",
        order = "bgl"
    },
    {
        type = "int-setting",
        name = "oarc-resource-2-amount",
        setting_type = "runtime-global",
        default_value = 1500,
        minimum_value = 0,
        order = "bgm"
    },    
    {
        type = "int-setting",
        name = "oarc-resource-2-size",
        setting_type = "runtime-global",
        default_value = 14,
        minimum_value = 0,
        order = "bgn"
    },

    -- Resource ore 3
    {
        type = "string-setting",
        name = "oarc-resource-3-name",
        setting_type = "runtime-global",
        default_value = "stone",
        order = "bgo"
    },
    {
        type = "int-setting",
        name = "oarc-resource-3-amount",
        setting_type = "runtime-global",
        default_value = 1000,
        minimum_value = 0,
        order = "bgp"
    },    
    {
        type = "int-setting",
        name = "oarc-resource-3-size",
        setting_type = "runtime-global",
        default_value = 12,
        minimum_value = 0,
        order = "bgr"
    },

    -- Resource ore 4
    {
        type = "string-setting",
        name = "oarc-resource-4-name",
        setting_type = "runtime-global",
        default_value = "coal",
        order = "bgs"
    },
    {
        type = "int-setting",
        name = "oarc-resource-4-amount",
        setting_type = "runtime-global",
        default_value = 1500,
        minimum_value = 0,
        order = "bgt"
    },    
    {
        type = "int-setting",
        name = "oarc-resource-4-size",
        setting_type = "runtime-global",
        default_value = 12,
        minimum_value = 0,
        order = "bgu"
    },

    -- Resource ore 5
    {
        type = "string-setting",
        name = "oarc-resource-5-name",
        setting_type = "runtime-global",
        default_value = "uranium",
        order = "bgv"
    },
    {
        type = "int-setting",
        name = "oarc-resource-5-amount",
        setting_type = "runtime-global",
        default_value = 0,
        minimum_value = 0,
        order = "bgw"
    },    
    {
        type = "int-setting",
        name = "oarc-resource-5-size",
        setting_type = "runtime-global",
        default_value = 0,
        minimum_value = 0,
        order = "bgx"
    },

    {
        type = "string-setting",
        name = "oarc-resource-patch-1-name",
        setting_type = "runtime-global",
        default_value = "crude-oil",
        order = "bgy"
    },
    {
        type = "int-setting",
        name = "oarc-resource-patch-1-count",
        setting_type = "runtime-global",
        default_value = 2,
        minimum_value = 0,
        order = "bgz"
    },    
    {
        type = "int-setting",
        name = "oarc-resource-patch-1-amount",
        setting_type = "runtime-global",
        default_value = 300000,
        minimum_value = 0,
        order = "bgza"
    },

    -- Timing/Cooldowns
    {
        type = "int-setting",
        name = "oarc-respawn-cooldown-min",
        setting_type = "runtime-global",
        default_value = 15,
        minimum_value = 0,
        order = "bha"
    },
    {
        type = "int-setting",
        name = "oarc-minimum-online-time",
        setting_type = "runtime-global",
        default_value = 15,
        minimum_value = 0,
        order = "bhb"
    },

    -- Soft mod stuff
    {
        type = "bool-setting",
        name = "oarc-enable-player-list",
        setting_type = "runtime-global",
        default_value = true,
        order = "bia"
    },
    {
        type = "bool-setting",
        name = "oarc-list-offline-players",
        setting_type = "runtime-global",
        default_value = true,
        order = "bib"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-undecorator",
        setting_type = "runtime-global",
        default_value = true,
        order = "bic"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-tags",
        setting_type = "runtime-global",
        default_value = true,
        order = "bid"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-long-reach",
        setting_type = "runtime-global",
        default_value = false,
        order = "bie"
    },
    {
        type = "bool-setting",
        name = "oarc-enable-autofill",
        setting_type = "runtime-global",
        default_value = false,
        order = "bif"
    },
})
