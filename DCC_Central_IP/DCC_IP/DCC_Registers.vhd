----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2018 01:10:46 PM
-- Design Name: 
-- Module Name: DCC_Registers - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DCC_TrameGen is
    Port ( Clk_100MHz : in std_logic;
           Reset : in std_logic;
           Button_L : in STD_LOGIC;
           Button_R : in STD_LOGIC;
           Button_C : in STD_LOGIC;
           Sw : in std_logic_vector (11 downto 0);
           DCC_Param_1 : out std_logic_vector (31 downto 0);    -- adresse de la locomotive
           DCC_Param_2 : out std_logic_vector (31 downto 0);    -- Commande 1
           DCC_Control : out std_logic_vector (31 downto 0));   -- Validation de la trame
end DCC_TrameGen;

architecture Behavioral of DCC_TrameGen is
attribute KEEP : string;
signal DCC_Param_1_reg : std_logic_vector (31 downto 0);
signal DCC_Param_2_reg : std_logic_vector (31 downto 0);
signal DCC_Control_reg : std_logic_vector (31 downto 0);
signal DCC_Param_sel   : integer range 0 to 1;
attribute KEEP of DCC_Param_1_reg : signal is "true";
attribute KEEP of DCC_Param_2_reg : signal is "true";
attribute KEEP of DCC_Control_reg : signal is "true";
signal pressed_L : std_logic;
signal pressed_R : std_logic;
signal pressed_C : std_logic;

begin
    DCC_Param_1 <= DCC_Param_1_reg;
    DCC_Param_2 <= DCC_Param_2_reg;
    DCC_Control <= DCC_Control_reg;
    process (Clk_100MHz, Reset, Button_L, Button_R, Button_C, Sw, DCC_Param_sel,
    pressed_L, pressed_R, pressed_C)
    begin
        if Reset = '1' then
            DCC_Param_1_reg <= x"00000000";
            DCC_Param_2_reg <= x"00000000";
            DCC_Control_reg <= x"00000000";
            DCC_Param_sel   <= 0;
            
            pressed_L <= '0';
            pressed_R <= '0';
            pressed_C <= '0';
        elsif rising_edge(Clk_100MHz) then
            -- Gestion du bouton Left
            if pressed_L = '0' and Button_L = '1' then
                pressed_L <= '1';
                if DCC_Param_sel = 2 then
                    DCC_Param_sel <= 0;
                else
                    DCC_Param_sel <= DCC_Param_sel + 1;
                end if; 
            elsif Button_L = '1' and pressed_L = '1' then
                pressed_L <= '1';
            else
                pressed_L <= '0';
            end if;
            -- Gestion du bouton Right
            if pressed_R = '0' and Button_R = '1' then
                pressed_R <= '1';
                if DCC_Param_sel = 0 then
                    DCC_Param_sel <= 1;
                else
                    DCC_Param_sel <= DCC_Param_sel - 1;
                end if; 
            elsif Button_R = '1' and pressed_R = '1' then
                pressed_R <= '1';
            else
                pressed_R <= '0';
            end if;
            -- Gestion du bouton Center (validation de trame)
            if pressed_C = '0' and Button_C = '1' then
                pressed_C <= '1';
                DCC_Control_Reg (0) <= '1';
            elsif Button_C = '1' and pressed_C = '1' then
                pressed_C <= '1';
                DCC_Control_Reg (0) <= '0';
            else
                pressed_C <= '0';
                DCC_Control_Reg (0) <= '0';
            end if;
            -- Commande de l'adresse, encodage One-Hot
            if DCC_Param_sel = 0 then
                if      Sw = x"001" then
                    DCC_Param_1_reg <= x"00000001";
                elsif   Sw = x"002" then
                    DCC_Param_1_reg <= x"00000002";
                elsif   Sw = x"004" then
                    DCC_Param_1_reg <= x"00000003";
                elsif   Sw = x"008" then
                    DCC_Param_1_reg <= x"00000004";
                elsif   Sw = x"010" then
                    DCC_Param_1_reg <= x"00000005";
                elsif   Sw = x"020" then
                    DCC_Param_1_reg <= x"00000006";
                elsif   Sw = x"040" then
                    DCC_Param_1_reg <= x"00000007";
                elsif   Sw = x"080" then
                    DCC_Param_1_reg <= x"00000008";
                elsif   Sw = x"100" then
                    DCC_Param_1_reg <= x"00000009";
                elsif   Sw = x"200" then
                    DCC_Param_1_reg <= x"0000000A";
                elsif   Sw = x"400" then
                    DCC_Param_1_reg <= x"0000000B";
                elsif   Sw = x"800" then
                    DCC_Param_1_reg <= x"0000000C";
                else
                    DCC_Param_1_reg <= x"00000000";
                end if;
            -- Commande 
            elsif DCC_Param_sel = 1 then
                if      Sw = x"001" then
                    DCC_Param_2_reg (16 downto 9) <= "01000000"; -- Stop
                elsif      Sw = x"002" then
                    DCC_Param_2_reg (16 downto 9) <= "01100011"; -- Step 3 Forward
                elsif      Sw = x"003" then
                    DCC_Param_2_reg (16 downto 9) <= "01110101"; -- Step 8 Forward
               elsif       Sw = x"004" then
                    DCC_Param_2_reg (16 downto 9) <= "01101000"; -- Step 13 Forward
                elsif      Sw = x"008" then
                    DCC_Param_2_reg (16 downto 9) <= "01000011"; -- Step 3 Backwards
                elsif      Sw = x"010" then
                    DCC_Param_2_reg (16 downto 9) <= "01010101"; -- Step 8 Backwards
                elsif      Sw = x"020" then
                    DCC_Param_2_reg (16 downto 9) <= "01001000"; -- Step 13 Backwards
                elsif   Sw = x"040" then
                    DCC_Param_2_reg (16 downto 9) <= "10010000"; -- Light ON
                elsif      Sw = x"080" then
                    DCC_param_2_reg (16 downto 9) <= "10000010"; -- Cor fran?aise 
                elsif       Sw = x"100" then 
                    DCC_param_2_reg (16 downto 9) <= "10100001"; -- ventilateur 
                elsif       Sw = x"200" then
                    DCC_param_2_reg (15 downto 0) <= "1101111000000001"; -- Annonce station fran?aise
                elsif       Sw = x"400" then
                    DCC_param_2_reg (15 downto 0) <= "1101111000000100"; -- Signal d'alerte fran?aise            
                elsif       Sw = x"800" then
                    DCC_param_2_reg (15 downto 0) <= "1101111001000000"; -- Liberation des freins   
                else
                    DCC_Param_2_reg (7 downto 0) <= "01000000"; -- Stop by default
    
                end if;
           end if;
        end if;
end process;
end Behavioral;
