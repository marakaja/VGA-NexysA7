library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel is
    port (
    -- Port definition for VGA Connector
    -- VGA_R[0]
    VGA_R0: out std_logic;
    -- VGA_R[1]
    VGA_R1: out std_logic;
    -- VGA_R[2]
    VGA_R2: out std_logic;
    -- VGA_R[3]
    VGA_R3: out std_logic;
    -- VGA_G[0]
    VGA_G0: out std_logic;
    -- VGA_G[1]
    VGA_G1: out std_logic;
    -- VGA_G[2]
    VGA_G2: out std_logic;
    -- VGA_G[3]
    VGA_G3: out std_logic;
    -- VGA_B[0]
    VGA_B0: out std_logic;
    -- VGA_B[1]
    VGA_B1: out std_logic;
    -- VGA_B[2]
    VGA_B2: out std_logic;
    -- VGA_B[3]
    VGA_B3: out std_logic;
    
    -- VGA_HS
    VGA_HS: out std_logic;
    -- VGA_VS
    VGA_VS: out std_logic;

    CLK100MHZ : in std_logic;

    LED : out std_logic_vector(7 downto 0);
    JA : out std_logic_vector(7 downto 0);
    
            --------------------
        -- SMSC Ethernet PHY
        --------------------
        ETH_MDC     : out std_logic;
        ETH_MDIO    : inout std_logic;
        ETH_RSTN    : out std_logic;
        ETH_CRSDV   : in  std_logic;
        ETH_RXERR   : in  std_logic;
        ETH_RXD     : in  std_logic_vector(1 downto 0);
        ETH_TXEN    : out std_logic;
        ETH_TXD     : out std_logic_vector(1 downto 0);
        ETH_REFCLK  : out std_logic            
        
        
    );

end toplevel;

architecture Behavioral of toplevel is

component pixelgen is
    port (
            clk : in    std_logic  ;
            pixel_data : out std_logic_vector(11 downto 0);
            row : in std_logic_vector(9 downto 0);
            col : in std_logic_vector(9 downto 0)
            );
end component pixelgen;

component simple_counter is
    generic (
        NBIT : integer := 3; --! Default number of counter bits
        PERIOD : integer range 1 to integer'high := 5; --! counter length
        SYNC_LOW : integer range 1 to integer'high; --! Counter value for sync low
        SYNC_HIGH : integer range 1 to integer'high --! Counter value for sync high
    );
    port (
        clk   : in    std_logic;                          --! Main clock
        rst   : in    std_logic;                          --! High-active synchronous reset
        en    : in    std_logic;                          --! Clock enable input
        count : out   std_logic_vector(NBIT - 1 downto 0); --! Counter value
        sync  : out   std_logic;
        counter_end : out std_logic     --! End of line
    );
end component simple_counter;

component FC1001_RMII is
    port (
        --Sys/Common
        Clk             : in  std_logic; --100 MHz
        Reset           : in  std_logic; --Active high
        UseDHCP         : in  std_logic; --'1' to use DHCP
        IP_Addr         : in  std_logic_vector(31 downto 0); --IP address if not using DHCP
        IP_Ok           : out std_logic; --DHCP ready

        --MAC/RMII
        RMII_CLK_50M    : out std_logic; --RMII continous 50 MHz reference clock
        RMII_RST_N      : out std_logic; --Phy reset, active low
        RMII_CRS_DV     : in  std_logic; --Carrier sense/Receive data valid
        RMII_RXD0       : in  std_logic; --Receive data bit 0
        RMII_RXD1       : in  std_logic; --Receive data bit 1
        RMII_RXERR      : in  std_logic; --Receive error, optional
        RMII_TXEN       : out std_logic; --Transmit enable
        RMII_TXD0       : out std_logic; --Transmit data bit 0
        RMII_TXD1       : out std_logic; --Transmit data bit 1
        RMII_MDC        : out std_logic; --Management clock
        RMII_MDIO       : inout std_logic; --Management data

        --UDP Basic Server
        UDP0_Reset      : in  std_logic; --Reset interface, active high
        UDP0_Service    : in  std_logic_vector (15 downto 0); --Service
        UDP0_ServerPort : in  std_logic_vector (15 downto 0); --UDP local server port
        UDP0_Connected  : out std_logic; --Client connected
        UDP0_OutIsEmpty : out std_logic; --All outgoing data acked
        UDP0_TxData     : in  std_logic_vector (7 downto 0); --Transmit data
        UDP0_TxValid    : in  std_logic; --Transmit data valid
        UDP0_TxReady    : out std_logic; --Transmit data ready
        UDP0_TxLast     : in  std_logic; --Transmit data last
        UDP0_RxData     : out std_logic_vector (7 downto 0); --Receive data
        UDP0_RxValid    : out std_logic; --Receive data valid
        UDP0_RxReady    : in  std_logic; --Receive data ready
        UDP0_RxLast     : out std_logic  --Transmit data last
    );
end component FC1001_RMII;



signal color : std_logic_vector(11 downto 0);
signal row : std_logic_vector(9 downto 0);
signal col : std_logic_vector(9 downto 0);
signal pixel_freq : std_logic;
signal endline : std_logic;

signal RX_data : std_logic_vector(7 downto 0);
signal RX_valid : std_logic;
signal RX_last : std_logic;




begin

VGA_R0 <= color(8);
VGA_R1 <= color(9);
VGA_R2 <= color(10);
VGA_R3 <= color(11);
VGA_G0 <= color(0);
VGA_G1 <= color(1);
VGA_G2 <= color(2);
VGA_G3 <= color(3);
VGA_B0 <= color(4);
VGA_B1 <= color(5);
VGA_B2 <= color(6);
VGA_B3 <= color(7);


-- UDP port is 81
eth : FC1001_RMII
    port map(
        Clk => CLK100MHZ,
        Reset => '0',
        UseDHCP => '0',
        IP_Addr =>  x"C0A8010F",
        IP_Ok => LED(4),

        RMII_CLK_50M => ETH_REFCLK,
        RMII_RST_N => ETH_RSTN,
        RMII_CRS_DV => ETH_CRSDV,
        RMII_RXD0 => ETH_RXD(0),
        RMII_RXD1 => ETH_RXD(1),
        RMII_RXERR => ETH_RXERR,
        RMII_TXEN => ETH_TXEN,
        RMII_TXD0 => ETH_TXD(0),
        RMII_TXD1 => ETH_TXD(1),
        RMII_MDC => ETH_MDC,
        RMII_MDIO => ETH_MDIO,

        UDP0_Reset => '0',
        UDP0_Service => (others => '0'),
        UDP0_ServerPort => x"0051",
        UDP0_Connected => LED(0),
        UDP0_OutIsEmpty => LED(5),

        UDP0_TxData => (others => '0'),
        UDP0_TxValid => '1',
        UDP0_TxReady => LED(1),
        UDP0_TxLast => '1',

        UDP0_RxData => RX_data,
        UDP0_RxValid => RX_valid,
        UDP0_RxReady => '1',
        UDP0_RxLast => RX_last
    );

pxlgen : pixelgen 
    port map(
        clk => CLK100MHZ,
        pixel_data => color,
        row => row,
        col => col
        );

CLOCK_DIV : simple_counter
    generic map (
        NBIT => 3,
        PERIOD => 5,
        SYNC_LOW => 1,
        SYNC_HIGH => 2
    )
    port map (
        clk => CLK100MHZ,
        rst => '0',
        en => '1',
        count => open,
        sync => open,
        counter_end => pixel_freq
    );

HSYNC : simple_counter
    generic map (
        NBIT => 10,
        PERIOD => 528,
        SYNC_LOW => 420,
        SYNC_HIGH => 484
    )
    port map (
        clk => pixel_freq,
        rst => '0',
        en => '1',
        count => col,
        sync => VGA_HS,
        counter_end => endline
    );

VSYNC : simple_counter
    generic map (
        NBIT => 10,
        PERIOD => 628,
        SYNC_LOW => 601,
        SYNC_HIGH => 605
    )
    port map (
        clk => endline,
        rst => '0',
        en => '1',
        count => row,
        sync => VGA_VS,
        counter_end => open
    );

    LED(6) <= '1';
    LED(7) <= '1';


end Behavioral;
