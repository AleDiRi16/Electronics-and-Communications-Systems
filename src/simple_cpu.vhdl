library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;


entity simple_cpu is
    generic(
        N : natural := 8; -- number of bits of the registers
        M : natural := 4 -- number of bits of the memory addresses
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        instr : in std_logic_vector(N-1 downto 0);
        pc : out std_logic_vector(M-1 downto 0);
        input : in std_logic_vector(N-1 downto 0);
        output : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture struct of simple_cpu is

    component DFF_N is
        generic (
          N : natural := 8
        );
        port (
          clk   : in std_logic;
          arstn : in std_logic;
          en    : in std_logic;
          d     : in std_logic_vector(N - 1 downto 0);
          q     : out std_logic_vector(N - 1 downto 0)
        );
      end component;
    -- component ROM
    component ripple_carry_adder is
        generic (
          Nbit : positive := 8
        );
        port (
          a    : in  std_logic_vector(Nbit - 1 downto 0);
          b    : in  std_logic_vector(Nbit - 1 downto 0);
          cin  : in  std_logic;
          s    : out std_logic_vector(Nbit - 1 downto 0);
          cout : out std_logic
        );
      end component;
    -- component moltiplicatore
    component multiplier is
        generic(
            Nbit : positive := 8
        );
        port (
            clk : in std_logic;
            reset   : in std_logic;
            en  : in std_logic;
            ow  : out std_logic;
            x : in std_logic_vector(Nbit - 1 downto 0);
            y : in std_logic_vector(Nbit - 1 downto 0);
            result : out std_logic_vector(Nbit - 1 downto 0);
        );
    end component;

    -- segnali per i registri interni
    signal R0_in : std_logic_vector(N-1 downto 0);
    signal R0_out : std_logic_vector(N-1 downto 0);
    signal R1_in : std_logic_vector(N-1 downto 0);
    signal R1_out : std_logic_vector(N-1 downto 0);
    signal R2_in : std_logic_vector(N-1 downto 0);
    signal R2_out : std_logic_vector(N-1 downto 0);
    signal R3_in : std_logic_vector(N-1 downto 0);
    signal R3_out : std_logic_vector(N-1 downto 0);
    signal SR_in : std_logic_vector(N-1 downto 0);
    signal SR_out : std_logic_vector(N-1 downto 0);
    signal IR_in : std_logic_vector(N-1 downto 0);
    signal IR_out : std_logic_vector(N-1 downto 0);
    signal PC_in : std_logic_vector(N-1 downto 0);
    signal PC_out : std_logic_vector(N-1 downto 0);
    signal REG_IN_in : std_logic_vector(N-1 downto 0);
    signal REG_IN_out : std_logic_vector(N-1 downto 0);
    signal REG_OUT_in : std_logic_vector(N-1 downto 0);
    signal REG_OUT_out : std_logic_vector(N-1 downto 0);
    ---
    signal SOMMATORE_a : std_logic_vector(N-1 downto 0);
    signal SOMMATORE_b : std_logic_vector(N-1 downto 0);
    signal SOMMATORE_s : std_logic_vector(N-1 downto 0);

    signal MOLTIPLICATORE_x : std_logic_vector(N-1 downto 0);
    signal MOLTIPLICATORE_y : std_logic_vector(N-1 downto 0);
    signal MOLTIPLICATORE_result : std_logic_vector(N-1 downto 0);

begin

    -- istanziare i registri (R0-R3, CSR)
    R0: DFF_N
        generic map(
            N => N
        )
        port map(
            clk   => clk,
            arstn => rst,
            en    => '1', -- ???????????????????
            d     => R0_in,
            q     => R0_out
        );

    R1: DFF_N
        generic map(
            N => N
        )
        port map(
            clk   => clk,
            arstn => rst,
            en    => '1', -- ???????????????????
            d     => R1_in,
            q     => R1_out
        );

    R2: DFF_N
    generic map(
        N => N
    )
    port map(
        clk   => clk,
        arstn => rst,
        en    => '1', -- ???????????????????
        d     => R2_in,
        q     => R2_out
    );

    R3: DFF_N
    generic map(
        N => N
    )
    port map(
        clk   => clk,
        arstn => rst,
        en    => '1', -- ???????????????????
        d     => R3_in,
        q     => R3_out
    );

    SR: DFF_N
    generic map(
        N => N
    )
    port map(
        clk   => clk,
        arstn => rst,
        en    => '1', -- ???????????????????
        d     => SR_in,
        q     => SR_out
    );

    IR: DFF_N
    generic map(
        N => N
    )
    port map(
        clk   => clk,
        arstn => rst,
        en    => '1', -- ???????????????????
        d     => IR_in,
        q     => IR_out
    );

    -- PC1 with 1 for distinguish it to pc
    PC1: DFF_N
    generic map(
        N => N
    )
    port map(
        clk   => clk,
        arstn => rst,
        en    => '1', -- ???????????????????
        d     => PC_in,
        q     => PC_out
    );
    -- istanziare le altre componenti

    REG_IN: DFF_N
        generic map(
            N => N
        )
        port map(
            clk   => clk,
            arstn => rst,
            en    => '1', -- ???????????????????
            d     => REG_IN_in,
            q     => REG_IN_out
        );

    REG_OUT: DFF_N
        generic map(
            N => N
        )
        port map(
            clk   => clk,
            arstn => rst,
            en    => '1', -- ???????????????????
            d     => REG_OUT_in,
            q     => REG_OUT_out
        );

    SOMMATORE: ripple_carry_adder 
        generic map(
          Nbit => N
        )
        port map(
          a    => SOMMATORE_a,
          b    => SOMMATORE_b,
          cin  => '0',
          s    => SOMMATORE_s,
          cout => open
        );

    MOLTIPLICATORE: ripple_carry_adder 
    generic map(
        Nbit => N
    )
    port map(
        clk => clk,
        reset   => rst,
        en  => '1', -- ?????????????????
        ow  => open, -- ??????????????? SR(2)
        x => MOLTIPLICATORE_x,
        y => MOLTIPLICATORE_y,
        result => MOLTIPLICATORE_result
    );

    simple_cpu_process: process(clk, rst)
        variable Nbit : natural := N;
    begin
        if rst = '0' then
            pc <= (others => '0');
            R0_in <= (others => '0');
            R1_in <= (others => '0');
            R2_in <= (others => '0');
            R3_in <= (others => '0');
            SR_in <= (others => '0');
            IR_in <= (others => '0');
            PC_in <= (others => '0');
        elsif rising_edge(clk) then
            case(instr(2 downto 0)) is
                -- RCSR
                when "000" =>
                    -- write SR in Rx
                    
                    case(instr(7 downto 6)) is
                        -- Rx0
                        when "00" => R0_in <= SR_out;

                        -- Rx1
                        when "01" => R1_in <= SR_out;

                        -- Rx2
                        when "10" => R2_in <= SR_out;

                        -- Rx3
                        when "11" => R3_in <= SR_out;

                        when others => null;
                    end case;
                    

                -- IN
                when "001" =>
                    -- send the input to the register REG_IN
                    REG_IN_in <= input;
                    -- wait clock
                    if(rising_edge(clk)) then
                        null;
                    end if;

                    case(instr(7 downto 6)) is
                        -- Rx0
                        when "00" =>
                            R0_in <= REG_IN_out;
                        -- Rx1
                        when "01" =>
                            R1_in <= REG_IN_out;
                        -- Rx2
                        when "10" =>
                            R2_in <= REG_IN_out;
                        -- Rx3
                        when "11" =>
                            R3_in <= REG_IN_out;
                        when others => null;
                    end case;

                    -- wait clock ?????????????
                -- OUT
                when "010" =>
                    case(instr(7 downto 6)) is
                        -- Rx0
                        when "00" =>
                            REG_OUT_in <= R0_out;
                        -- Rx1
                        when "01" =>
                            REG_OUT_in <= R1_out;
                        -- Rx2
                        when "10" =>
                            REG_OUT_in <= R2_out;
                        -- Rx3
                        when "11" =>
                            REG_OUT_in <= R3_out;
                        when others => null;
                    end case;
                    -- wait clock ?????????????
                -- MOV
                when "011" =>
                       case(instr(7 downto 6)) is
                        -- Rx0
                        when "00" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" => R0_in <= R0_out;
        
                                -- Ry1
                                when "01" => R1_in <= R0_out;
        
                                -- Ry2
                                when "10" => R2_in <= R0_out;
        
                                -- Ry3
                                when "11" => R3_in <= R0_out;
        
                                when others => null;
                            end case;
                        -- Rx1
                        when "01" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" => R0_in <= R1_out;
        
                                -- Ry1
                                when "01" => R1_in <= R1_out;
        
                                -- Ry2
                                when "10" => R2_in <= R1_out;
        
                                -- Ry3
                                when "11" => R3_in <= R1_out;
        
                                when others => null;
                            end case;
                        -- Rx2
                        when "10" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" => R0_in <= R2_out;
        
                                -- Ry1
                                when "01" => R1_in <= R2_out;
        
                                -- Ry2
                                when "10" => R2_in <= R2_out;
        
                                -- Ry3
                                when "11" => R3_in <= R2_out;
        
                                when others => null;
                            end case;
                        -- Rx3
                        when "11" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" => R0_in <= R3_out;
        
                                -- Ry1
                                when "01" => R1_in <= R3_out;
        
                                -- Ry2
                                when "10" => R2_in <= R3_out;
        
                                -- Ry3
                                when "11" => R3_in <= R3_out;
        
                                when others => null;
                            end case;
                        when others => null;
                    end case; 
                -- ADD
                when "100" =>
                    case(instr(7 downto 6)) is
                        -- Rx0
                        when "00" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" =>
                                    -- !!!!!!!!!!!!!!!!! controllare e copiare e incollare
                                    SR_in(2) <= R0_out(N-1) & R0_out(N-1);

                                    SOMMATORE_a <= R0_out;
                                    SOMMATORE_b <= R0_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R0_in <= SOMMATORE_s;
                                    if(SOMMATORE_s = "00000000") then
                                        SR_in(3) <= '1';
                                    else
                                        SR_in(3) <= '0';
                                    end if;
                                -- Ry1
                                when "01" =>
                                    SOMMATORE_a <= R0_out;
                                    SOMMATORE_b <= R1_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R1_in <= SOMMATORE_s;
                                -- Ry2
                                when "10" =>
                                    SOMMATORE_a <= R0_out;
                                    SOMMATORE_b <= R2_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R2_in <= SOMMATORE_s;
                                -- Ry3
                                when "11" =>
                                    SOMMATORE_a <= R0_out;
                                    SOMMATORE_b <= R3_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R3_in <= SOMMATORE_s;
                                when others => null;
                            end case;
                        -- Rx1
                        when "01" =>
                            case(instr(5 downto 4)) is
                                when "00" =>
                                -- Ry0
                                SOMMATORE_a <= R1_out;
                                SOMMATORE_b <= R0_out;
                                --- wait clock
                                if(rising_edge(clk)) then
                                    null;
                                end if;

                                R0_in <= SOMMATORE_s;
                                -- Ry1
                                when "01" =>
                                    SOMMATORE_a <= R1_out;
                                    SOMMATORE_b <= R1_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R1_in <= SOMMATORE_s;
                                    -- Ry2
                                when "10" =>
                                    SOMMATORE_a <= R1_out;
                                    SOMMATORE_b <= R2_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R2_in <= SOMMATORE_s;
                                -- Ry3
                                when "11" =>
                                    SOMMATORE_a <= R1_out;
                                    SOMMATORE_b <= R3_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R3_in <= SOMMATORE_s;
                                when others => null;
                            end case;
                        -- Rx2
                        when "10" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" =>
                                    SOMMATORE_a <= R2_out;
                                    SOMMATORE_b <= R0_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R0_in <= SOMMATORE_s;
                                -- Ry1
                                when "01" =>
                                    SOMMATORE_a <= R2_out;
                                    SOMMATORE_b <= R1_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R1_in <= SOMMATORE_s;
                                -- Ry2
                                when "10" =>
                                    SOMMATORE_a <= R2_out;
                                    SOMMATORE_b <= R2_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R2_in <= SOMMATORE_s;
                                -- Ry3
                                when "11" =>
                                    SOMMATORE_a <= R2_out;
                                    SOMMATORE_b <= R3_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R3_in <= SOMMATORE_s;
                                when others => null;
                            end case;
                        -- Rx3
                        when "11" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" =>
                                    SOMMATORE_a <= R3_out;
                                    SOMMATORE_b <= R0_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R0_in <= SOMMATORE_s;
                                -- Ry1
                                when "01" =>
                                    SOMMATORE_a <= R3_out;
                                    SOMMATORE_b <= R1_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R1_in <= SOMMATORE_s;
                                -- Ry2
                                when "10" =>
                                    SOMMATORE_a <= R3_out;
                                    SOMMATORE_b <= R2_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R2_in <= SOMMATORE_s;
                                -- Ry3
                                when "11" =>
                                    SOMMATORE_a <= R3_out;
                                    SOMMATORE_b <= R3_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R3_in <= SOMMATORE_s;
                                when others => null;
                            end case;
                        when others => null;
                    end case;
                --MUL
                when "101" =>
                    case(instr(7 downto 6)) is
                        -- Rx0
                        when "00" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" =>
                                    MOLTIPLICATORE_x <= R0_out;
                                    MOLTIPLICATORE_y <= R0_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R0_in <= MOLTIPLICATORE_result;
                                -- Ry1
                                when "01" =>
                                    MOLTIPLICATORE_x <= R0_out;
                                    MOLTIPLICATORE_y <= R1_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R1_in <= MOLTIPLICATORE_result;
                                -- Ry2
                                when "10" =>
                                    MOLTIPLICATORE_x <= R0_out;
                                    MOLTIPLICATORE_y <= R2_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R2_in <= MOLTIPLICATORE_result;
                                -- Ry3
                                when "11" =>
                                    MOLTIPLICATORE_x <= R0_out;
                                    MOLTIPLICATORE_y <= R3_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R3_in <= MOLTIPLICATORE_result;
                                when others => null;
                            end case;
                        -- Rx1
                        when "01" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" =>
                                    MOLTIPLICATORE_x <= R1_out;
                                    MOLTIPLICATORE_y <= R0_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R0_in <= MOLTIPLICATORE_result;
                                -- Ry1
                                when "01" =>
                                    MOLTIPLICATORE_x <= R1_out;
                                    MOLTIPLICATORE_y <= R1_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R1_in <= MOLTIPLICATORE_result;
                                -- Ry2
                                when "10" =>
                                    MOLTIPLICATORE_x <= R1_out;
                                    MOLTIPLICATORE_y <= R2_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R2_in <= MOLTIPLICATORE_result;
                                -- Ry3
                                when "11" =>
                                    MOLTIPLICATORE_x <= R1_out;
                                    MOLTIPLICATORE_y <= R3_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R3_in <= MOLTIPLICATORE_result;
                                when others => null;
                            end case;
                        -- Rx2
                        when "10" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" =>
                                    MOLTIPLICATORE_x <= R2_out;
                                    MOLTIPLICATORE_y <= R0_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R0_in <= MOLTIPLICATORE_result;
                                -- Ry1
                                when "01" =>
                                    MOLTIPLICATORE_x <= R2_out;
                                    MOLTIPLICATORE_y <= R1_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R1_in <= MOLTIPLICATORE_result;
                                -- Ry2
                                when "10" =>
                                    MOLTIPLICATORE_x <= R2_out;
                                    MOLTIPLICATORE_y <= R2_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R2_in <= MOLTIPLICATORE_result;
                                -- Ry3
                                when "11" =>
                                    MOLTIPLICATORE_x <= R2_out;
                                    MOLTIPLICATORE_y <= R3_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R3_in <= MOLTIPLICATORE_result;
                                when others => null;
                            end case;
                        -- Rx3
                        when "11" =>
                            case(instr(5 downto 4)) is
                                -- Ry0
                                when "00" =>
                                    MOLTIPLICATORE_x <= R3_out;
                                    MOLTIPLICATORE_y <= R0_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R0_in <= MOLTIPLICATORE_result;
                                -- Ry1
                                when "01" =>
                                    MOLTIPLICATORE_x <= R3_out;
                                    MOLTIPLICATORE_y <= R1_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R1_in <= MOLTIPLICATORE_result;
                                -- Ry2
                                when "10" =>
                                    MOLTIPLICATORE_x <= R3_out;
                                    MOLTIPLICATORE_y <= R2_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R2_in <= MOLTIPLICATORE_result;
                                -- Ry3
                                when "11" =>
                                    MOLTIPLICATORE_x <= R3_out;
                                    MOLTIPLICATORE_y <= R3_out;
                                    --- wait clock
                                    if(rising_edge(clk)) then
                                        null;
                                    end if;

                                    R3_in <= MOLTIPLICATORE_result;
                                when others => null;
                            end case;
                        when others => null;
                    end case;
                -- LSL
                when "110" =>
                    case(instr(7 downto 6)) is
                        -- Rx0
                        when "00" =>
                            SR_in(1) <= R0_out(N-1);
                            R0_in <= R0_out(N-2 downto 0) & '0';
                        -- Rx1
                        when "01" =>
                            SR_in(1) <= R1_out(N-1);
                            R1_in <= R1_out(N-2 downto 0) & '0';
                        -- Rx2
                        when "10" =>
                            SR_in(1) <= R2_out(N-1);
                            R2_in <= R2_out(N-2 downto 0) & '0';
                        -- Rx3
                        when "11" =>
                            SR_in(1) <= R3_out(N-1);
                            R3_in <= R3_out(N-2 downto 0) & '0';
                        when others => null;
                    end case;
                -- LSR
                when "111" =>
                    case(instr(7 downto 6)) is
                        -- Rx0
                        when "00" =>
                            SR_in(1) <= R0_out(0);
                            R0_in <= '0' & R0_out(N-1 downto 1);
                        -- Rx1
                        when "01" =>
                            SR_in(1) <= R1_out(0);
                            R1_in <= '0' & R1_out(N-1 downto 1);
                        -- Rx2
                        when "10" =>
                            SR_in(1) <= R2_out(0);
                            R2_in <= '0' & R2_out(N-1 downto 1);
                        -- Rx3
                        when "11" =>
                            SR_in(1) <= R3_out(0);
                            R3_in <= '0' & R3_out(N-1 downto 1);
                        when others => null;
                    end case;
                when others => null;
            end case;
        end if;
    end process;

end architecture;