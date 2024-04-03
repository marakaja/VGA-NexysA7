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
        UDP0_Service    : in  std_logic_vector(15 downto 0); --Service
        UDP0_ServerPort : in  std_logic_vector(15 downto 0); --UDP local server port
        UDP0_Connected  : out std_logic; --Client connected
        UDP0_OutIsEmpty : out std_logic; --All outgoing data acked
        UDP0_TxData     : in  std_logic_vector(7 downto 0); --Transmit data
        UDP0_TxValid    : in  std_logic; --Transmit data valid
        UDP0_TxReady    : out std_logic; --Transmit data ready
        UDP0_TxLast     : in  std_logic; --Transmit data last
        UDP0_RxData     : out std_logic_vector(7 downto 0); --Receive data
        UDP0_RxValid    : out std_logic; --Receive data valid
        UDP0_RxReady    : in  std_logic; --Receive data ready
        UDP0_RxLast     : out std_logic  --Transmit data last
    );
end component;
