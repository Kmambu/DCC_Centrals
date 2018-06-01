----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kevin Mambu, Insaf Brahimi
-- 
-- Create Date: 03/30/2018 04:54:12 PM
-- Design Name: 
-- Module Name: Clock_Divider - Behavioral
-- Project Name: 
-- Target Devices: DCC Central (Nexys4DDR)
-- Tool Versions: Vivado 2017.1
-- Description: Genere un signal d'horloge de frequence 1MHz a partir 
--              de l'horloge 100MHz de la carte
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clock_Divider is
    Port ( Clk_100MHz : in STD_LOGIC;
           Clk_1MHz : out STD_LOGIC;
           Reset : in STD_LOGIC);
end Clock_Divider;

architecture Behavioral of Clock_Divider is
signal delay : integer range 0 to 127;
signal clk_out : std_logic;
begin
    process(Clk_100MHz,Reset)
    begin
        if Reset = '1' then
            clk_out <= Clk_100MHz; -- Both signals should not be unphased
            delay <= 0;
        elsif rising_edge(Clk_100MHz) then
            if delay + 1 = 50 then
                clk_out <= not clk_out;
                delay <= 0;
            else
                delay <= delay + 1;
            end if;
        end if;
    end process;
    Clk_1MHz <= clk_out;
end Behavioral;
