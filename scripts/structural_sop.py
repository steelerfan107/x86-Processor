import argparse
import os
import subprocess
import re 
import string

#input
parser = argparse.ArgumentParser(description="Script to turn Espresso outputs into Verilog modules")
parser.add_argument("--pi",required=True,help="Path to input file")
args = parser.parse_args()

input = args.pi
wire_output_module_list = []
and_output_module_list = []
or_output_module_list = []
inv_output_module_list = []
assign_output_module_list = []
module_dictionary = {}

console_out = subprocess.run(['./espresso.linux', '-o', 'eqntott', input], stdout=subprocess.PIPE)
result = console_out.stdout
#logic_string = result.decode('utf-8').partition("specified above.")[2]
logic_string = result.decode('utf-8')
#logic_string = result
logic_string_array = logic_string.split(';')
and_gate_num = 0
or_gate_num = 0

for i in range(len(logic_string_array)):
    output_var = logic_string_array[i].partition('=')[0]
    var_logic = logic_string_array[i].partition('=')[2]
    products = var_logic.replace('(', "")
    products = products.replace(')', "")
    products = products.replace(' ', '')
    products = products.replace("\n",'');
    products = products.split('|')
    for j in products:
        product_terms = j.split('&')
        for k in product_terms:
            if(k.find('!') != -1):
                if k in module_dictionary:
                    pass
                else:
                    raw_term = k.replace('!', '')
                    raw_term = raw_term.replace(' ', '')
                    wire_output_module_list.append("wire " + raw_term + "_not;")
                    module_dictionary[k] = raw_term + "_not"
                    inv_output_module_list.append("inv1$ " + raw_term + "_inv " + "(.out(" + raw_term + "_not), .in(" + raw_term + "));")
        and_size = len(product_terms)
        and_wire = "and" + str(and_gate_num)
        and_wire_code = "wire " + and_wire + ";"
        if(and_size > 1):
            wire_output_module_list.append(and_wire_code)
            and_module = "and" + str(and_size) + "$ and_gate" + str(and_gate_num) + "(.out(" + and_wire + "),"
            for x in range(and_size):
                if(x == (and_size-1)):
                    if(product_terms[x].find("!") != -1):
                        and_module += " .in" + str(x) + "(" + (module_dictionary[product_terms[x]]) + "));"
                    else:
                        and_module += " .in" + str(x) + "(" + (product_terms[x]) + "));"
                else:
                    if(product_terms[x].find("!") != -1):
                        and_module += " .in" + str(x) + "(" + (module_dictionary[product_terms[x]]) + "),"
                    else:
                        and_module += " .in" + str(x) + "(" + (product_terms[x]) + "),"
            and_gate_num += 1
            and_output_module_list.append(and_module)
            module_dictionary[j] = and_wire
    or_size = len(products)
    or_wire = "or" + str(or_gate_num)
    or_wire_code = "wire " + or_wire + ";"
    if(or_size > 1):
        wire_output_module_list.append(or_wire_code)
        or_module = "or" + str(or_size) + "$ or_gate" + str(or_gate_num) + "(.out(" + or_wire + "),"
        for y in range(or_size):
            if(y == (or_size-1)):
                or_module += " .in" + str(y) + "(" + (module_dictionary[products[y]]) + "));"
            else:
                or_module += " .in" + str(y) + "(" + (module_dictionary[products[y]]) + "),"
        or_gate_num += 1
        or_output_module_list.append(or_module)

        assign_out = "assign " + output_var + "= " + or_wire + ";"
        assign_out = assign_out.replace('\n', '')
        assign_output_module_list.append(assign_out)
    else:
        if(i < len(logic_string_array)-1):
            assign_out = "assign " + output_var + "= " + wire_output_module_list[-1].replace("wire ", "")
            assign_out = assign_out.replace('\n', '')
            assign_output_module_list.append(assign_out)



for i in wire_output_module_list:
    print(i)

print()

for i in inv_output_module_list:
    print(i)

print()

for i in and_output_module_list:
    print(i)

print()

for i in or_output_module_list:
    print(i)

print()

for i in assign_output_module_list:
    print(i)






