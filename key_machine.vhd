----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:26:34 06/04/2019 
-- Design Name: 
-- Module Name:    key_machine - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_machine is
	port(
	   clk, reset: in  std_logic;
      ps2d, ps2c: in  std_logic;
      key: out std_logic_vector(7 downto 0);
		flag_ler: out std_logic
	);
end key_machine;

architecture Behavioral of key_machine is

component kb_code is
   generic(W_SIZE: integer:=2);  -- 2^W_SIZE words in FIFO
   port (
      clk, reset: in  std_logic;
      ps2d, ps2c: in  std_logic;
      rd_key_code: in std_logic;
      key_code: out std_logic_vector(7 downto 0);
      kb_buf_empty: out std_logic
   );
end component kb_code;

signal estado: std_logic;
signal flush: std_logic;
signal key: std_logic_vector (7 downto 0) := "00000000";
signal state: natural range 0 to 2 := 0;

begin

kbcode: kb_code port map(clk, reset, ps2d, ps2c, flush, key_code, estado);



process(clk)
begin
	if (clk'event and clk='1') then
		case state is
			when 0 => if estado = '0' then
							state <=1;
							flush <= '0'; 
							flag_ler <= '0';
							key <= key_code;
						 end if;
			when 1 => 
				flag_ler <= '1'; 
				state <= '2';
				flush <= 0;							 
			when 2 => flush <= '1'; 
						 flag_ler <= '0';
						 state <= '0';  
			end case;
		end if;
   end process;
end Behavioral;
