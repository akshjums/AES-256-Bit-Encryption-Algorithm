library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Positive_edge_detect is
port(input: in std_logic;
		clock:in std_logic;
		--reset: in std_logic;
		Edge_out: out std_logic
	);
end Positive_edge_detect;

architecture Behavioral of Positive_edge_detect is
signal buff: std_logic; 
signal inv_buff:std_logic;
begin
	inv_buff<=not buff;
	Edge_out<=input and inv_buff;
	
	process(clock)
	begin
		if(clock'event and clock='1') then
			buff<=input;
		end if;
	end process;

end Behavioral;
