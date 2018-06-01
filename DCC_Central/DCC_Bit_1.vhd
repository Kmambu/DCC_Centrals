----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2018 09:25:10 AM
-- Design Name: 
-- Module Name: DCC_Bit_0 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DCC_Bit_1 is
    Port ( GO_1 : in STD_LOGIC;
           FIN_1 : out STD_LOGIC;
           DCC_1 : out STD_LOGIC;
           Clk_1MHz : in std_logic;
           Clk_100MHz : in std_logic;
           Reset : in std_logic);
end DCC_Bit_1;

architecture Behavioral of DCC_Bit_1 is
type state_type is (WAIT_ST, GEN0_ST, GEN1_ST, FIN_ST);
attribute KEEP : string;
signal cur_state, next_state : state_type;
attribute KEEP of cur_state : signal is "true";
attribute KEEP of next_state : signal is "true";
signal cpt : integer range 0 to 100;
signal gen0_done : std_logic;
signal gen1_done : std_logic;
begin
    clocked : process (Clk_100MHz,Reset)
    begin
        if Reset = '1' then
            cur_state <= WAIT_ST;
        elsif rising_edge(Clk_100MHz) then
            cur_state <= next_state;
        end if;
    end process clocked;
    
    state_updt : process (Clk_1MHz, cur_state, GO_1, cpt, gen0_done, gen1_done)
    begin
        case cur_state is
            when WAIT_ST =>
                DCC_1 <= '0';
                FIN_1 <= '0';
                if GO_1 = '1' then
                    next_state <= GEN0_ST;
                else
                    next_state <= WAIT_ST;
                end if;
            when GEN0_ST =>
                DCC_1 <= '0';
                FIN_1 <= '0';
                if gen0_done = '1' then
                    next_state <= GEN1_ST;
                else
                    next_state <= GEN0_ST;
                end if;
            when GEN1_ST =>
                DCC_1 <= '1';
                FIN_1 <= '0';
                if gen1_done = '1' then
                    next_state <= FIN_ST;
                else 
                    next_state <= GEN1_ST;    
                end if;
            when FIN_ST =>
                DCC_1 <= '0';
                FIN_1 <= '1';
                next_state <= WAIT_ST;
        end case;
    end process state_updt;
    
    
    count : process (Reset, Clk_1MHz, cpt, cur_state, next_state)
    begin
        if Reset = '1' then
            cpt <= 0;
        elsif rising_edge(Clk_1MHz) then
            if cur_state = GEN0_ST then
                if cpt = 58 then
                    cpt <= 0;
                    gen0_done <= '1';
                    gen1_done <= '0';
                else
                    gen0_done <= '0';
                    gen1_done <= '0';
                    cpt <= cpt + 1;
                end if;
            elsif cur_state = GEN1_ST then
                if cpt = 58 then
                    cpt <= 0;
                    gen0_done <= '0';
                    gen1_done <= '1';
                else
                    gen0_done <= '0';
                    gen1_done <= '0';
                    cpt <= cpt + 1;
                end if;
            else
                gen0_done <= '0';
                gen1_done <= '0';
                cpt <= 0;
            end if;
        end if;
    end process count;
end Behavioral;
