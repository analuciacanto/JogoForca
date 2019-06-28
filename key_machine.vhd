---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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

type states is ( estadoInicial, estadoIntermediario, estadoFinal);

signal estadoAtual : states := estadoInicial;
signal proximoEstado : states;

signal flush: std_logic := 0;
signal key_code: std_logic_vector (7 downto 0) := "00000000";
signal key_buf: std_logic_vector (7 downto 0) := "00000000";
-- signal state: natural range 0 to 2 := 0;
signal clkcount:unsigned (5 downto 0) := "000000";
signal oneusclk: std_logic; 
signal emptyBuffer : STD_LOGIC;

begin
kbcode: kb_code port map(clk, reset, ps2d, ps2c, flush, key_code, emptyBuffer);
key <= key_buf;

	-- Divisor de clock 
	process (CLK, oneUSClk)
    		begin
			if (CLK = '1' and CLK'event) then
				clkCount <= clkCount + 1;
			end if;
		end process;
	--  This makes oneUSClock peak once every 1 microsecond

	oneUSClk <= clkCount(5);

process(oneUSClk, estadoAtual, state, reset, )
begin
	if (oneUSClk = '1' and oneUSClk'event) then
		if estadoAtual = estadoInicial then
		 	 if (emptyBuffer = '0') then
				estadoAtual <= estadoIntermediario;
				flush <= '1'; -- 0
				flag_ler <= '0';
				key_buff <= ;
			else 
				estadoAtual <= estadoInicial;
				flush <='0';
				flag_ler <= '0';
				key_buf <= key_buf;
			end if;
		elsif (estadoAtual = estadoIntermediario) then
			estadoAtual <= estadoFinal;
			flag_ler <= '1';			
			flush <= '0';		
			key_buf <= key_code;
		elsif ( estadoAtual = estadoFinal) then
			estadoAtual <= estadoInicial;
			flush <= '0'; 
			flag_ler <= '0';
			key_buf <= key_buf;
		end if;
	end if;
end process;





		-
				
		



	elsif (oneUSClk'event and oneUSClk='1') then
		case state is
			when 0 => if estado = '0' then
							state <=1;
							flush <= '1'; 
							flag_ler <= '0';
							key_buf <= key_code;
						else
							state <= 0;
							flush <='0';
							flag_ler <= '0';
							key_buf <= key_buf;
						 end if;
			when 1 => 
				flag_ler <= '1'; 
				state <= 2;
				flush <= '0';		
					key_buf <= key_buf;
			when 2 => flush <= '0'; 
						 flag_ler <= '0';
						 state <= 0;  
						 key_buf <= key_buf;
			end case;
		end if;
   end process;
end Behavioral;
