-------------------------------------------------
--! @brief N-bit binary counter (Ver. internar unsigned)
--! @version 1.3
--! @copyright (c) 2019-2024 Tomas Fryza, MIT license
--!
--! Implementation of N-bit up counter with enable input and
--! high level reset. The width of the counter (number of bits)
--! is set generically using `NBIT`. The data type of the
--! internal counter is `unsigned`.
--!
--! Developed using TerosHDL, Vivado 2023.2, and EDA Playground.
--! Tested on Nexys A7-50T board and xc7a50ticsg324-1L FPGA.
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all; -- Package for data types conversion

-------------------------------------------------

entity simple_counter is
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
        counter_end : out std_logic := '0'    --! End of line
    );
end entity simple_counter;

-------------------------------------------------

architecture behavioral of simple_counter is
    --! Local counter
    signal sig_count : unsigned (NBIT - 1 downto 0) := (others => '0');
    signal sig_sync  : std_logic := '1';
    signal sig_counter_end : std_logic;

begin

    --! Clocked process with synchronous reset which implements
    --! N-bit up counter.
    p_simple_counter : process (clk) is
    begin

        if (rising_edge(clk)) then
            -- Synchronous, active-high reset
            if (rst = '1') then
                sig_count <= (others => '0');

            -- Clock enable activated
              
            
            elsif (en = '1') then
                sig_count <= sig_count + 1; -- increment counter
                
                if (sig_count = PERIOD - 1) then -- end period
                    sig_count <= (others => '0');
                    sig_counter_end <= '1';
                else
                    sig_counter_end <= '0';
                end if;
                
                if (sig_count = SYNC_LOW - 1) then -- signal sync low
                    sig_sync <= '0';
                elsif (sig_count = SYNC_HIGH - 1) then
                    sig_sync <= '1';
                end if;
            -- Each `if` must end by `end if`
            end if;
        end if;
    end process p_simple_counter;

    -- Assign internal register to output
    -- Note: unsigned--> std_logic vector
    count <= std_logic_vector(sig_count);
    sync <= sig_sync;
    counter_end <= sig_counter_end;

end architecture behavioral;