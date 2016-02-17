library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity auth is
port( clock: in std_logic;
		reset1: in std_logic;
		b1: in std_logic;
		b2:in std_logic;
		b3: in std_logic;
		leds: out std_logic_vector(2 downto 0);
		load_cv_sig: out std_logic
		);
end auth;

architecture rtl of auth is
component debounce IS
  GENERIC(
    counter_size  :  INTEGER := 19); --counter size (19 bits gives 10.5ms with 50MHz clock)
  PORT(
    clk     : IN  STD_LOGIC;  --input clock
    button  : IN  STD_LOGIC;  --input signal to be debounced
    result  : OUT STD_LOGIC); --debounced signal
END component;

Type Auth_state_type is(lock,state_1,state_2,state_3,state_4, state_5, unlock);
signal Auth_st: Auth_state_type;
signal pb1: std_logic;
signal pb2: std_logic;
signal pb3: std_logic;
signal reset : std_logic;
signal trigger: std_logic;
signal trigger_o: std_logic;
signal time_out: integer;
signal lock_counter1: integer;
signal lock_counter2: integer;
--signal lock_counter3: integer;
signal comp:std_logic;
begin
button_1: debounce 
  PORT map(
    clk     => clock,  --input clock
    button  =>  b1,--input signal to be debounced
    result  => pb1); --debounced signal
button_2: debounce 
  PORT map(
    clk     => clock,  --input clock
    button  =>  b2,--input signal to be debounced
    result  => pb2); --debounced signal
button_3: debounce 
  PORT map(
    clk     => clock,  --input clock
    button  =>  b3,--input signal to be debounced
    result  => pb3); --debounced signal
reset_button: debounce 
  PORT map(
    clk     => clock,  --input clock
    button  =>  reset1,--input signal to be debounced
    result  => reset); --debounced signal
trigger_o <= trigger or '1';
process(clock, reset)
begin
	if(reset='1') then
		load_cv_sig<='0';
		Auth_st<=lock;
		time_out <=0;
		lock_counter1<=0;
		lock_counter2<=0;
		--lock_counter3<=0;
		leds <="000";
	elsif(clock'event and clock='1') then
		comp <= pb1 xor pb2;
		case Auth_st is
			when lock=>
				lock_counter1<=0;
				lock_counter2<=0;
				leds<="001";
				load_cv_sig<='0';
			   --if(lock_counter3=25000000) then
					--lock_counter3<=0;
					if(pb1='1' and pb2='0' and pb3='0') then
						trigger <= '1';
						Auth_st<= state_1;
						time_out <=0;
				
					end if;
				--else lock_counter3<=lock_counter3+1;
				--end if;
				
			when state_1=>
				leds<="010";
				if(pb1='0' and pb3='0') then
					trigger <='0';
					if(pb2='1') then
						trigger <='1';
						Auth_st<= state_2;
						time_out <=0;
				
					end if;
				elsif(((pb1='1' or pb3='1') and trigger ='0') or (pb1='1' and pb2='1') or (pb1='1' and pb3='1')) then
					Auth_st<=lock;
				end if;
	      
			when state_2=>
	         leds <="010";
				if(pb1='0' and pb2='0') then
					trigger<='0';
					if(pb3='1') then
						trigger <='1';
						Auth_st<=state_3;
						time_out <=0;
				
					end if;
				elsif(((pb1='1' or pb2='1') and trigger='0') or (pb2='1' and pb3='1') or (pb1='1' and pb2='1')) then
					Auth_st<=lock;
				end if;
			
			when state_3=>
				leds<="010";
				if(pb3='0') then
					trigger <='0';
					if(pb1='1' and pb2='1') then
						trigger <='1';
						Auth_st<= state_4;
						time_out <=0;
						elsif(comp ='1') then
						if(lock_counter1=5000000) then
							lock_counter1<=0;
							Auth_st<=lock;
						else lock_counter1<=lock_counter1+1;
						end if;
					end if;
				elsif((pb3='1' and trigger='0') or(pb2='1' and pb3='1') or (pb1='1' and pb3='1'))then
					Auth_st<=lock;
				end if;

			when state_4=>
			
				leds <= "010";
				if(pb1='0' and pb2='0') then
					trigger <='0';
					if(pb3='1') then
						trigger <='1';
						Auth_st<= state_5;
						time_out <=0;
					end if;
				elsif((pb1='1' and pb2='1' and trigger ='0') or (pb1='1' and pb3='1') or (pb2='1' and pb3='1')) then
					Auth_st <= lock;
				elsif(comp = '1') then
					if(lock_counter2=5000000) then
							lock_counter2<=0;
							Auth_st<=lock;
					else lock_counter2<=lock_counter2+1;
					end if;
				end if;
			when state_5=>
	         
				leds <="010";
				if(pb3='0' and pb2 ='0') then
					trigger<='0';
					if(pb1='1') then
						trigger <='1';
						Auth_st<=unlock;
						time_out <=0;
					end if;
				elsif( ((pb2='1' or pb3='1') and trigger='0') or (pb1='1' and pb3='1') or (pb2='1' and pb3='1')) then
					Auth_st<=lock;
				end if;


	when unlock=>
	time_out <=0;
	
			leds <="100";
				load_cv_sig<='1';
				if(pb1='0' and pb3='0') then
					trigger <='0';
					if(pb2='1') then
						trigger <='1';
						Auth_st<=lock;
					end if;
				elsif(((pb1='1' or pb3='1') and trigger='0') or (pb1='1' and pb3='1') or (pb2='1' and pb3='1')) then
					Auth_st<=lock;
				end if;
	when others=> 
			Auth_st<=lock;
	end case;
	if(time_out=1000000000) then
							time_out<=0;
							Auth_st<=lock;
					else
					time_out<=time_out+1;
					end if;
		end if;
	end process;

	
end rtl;
