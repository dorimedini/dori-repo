#ifndef __ATTRIBUTES_H
#define __ATTRIBUTES_H

/** REMOVE THIS BEFORE SUBMITTION (SET DEBUG TO 0)! */
#define DEBUG 0
#if DEBUG
	#define DO_DEBUG(code) do { \
			code; \
		} while(0)
	#define DO_RELEASE(code)
#else
	#define DO_DEBUG(code)
	#define DO_RELEASE(code) do { \
			code; \
		} while(0)
#endif

#include <vector>
#include <string>
#include <list>
#include <iostream>
using std::vector;
using std::string;
using std::list;
using std::cout;
using std::endl;
	
/*******************************
			DECLARATIONS
*******************************/
extern bool g_is_last_type_declaration_matrix;
	
// Each token may or may not be an instance of ID (an identifier),
// and may or may not be a matrix.
// It may be other things (operators, etc.), but if it is bison
// has all the information it needs simply by knowing what the
// token is (we don't care if an LP token is constant or not).
typedef struct {
	bool is_matrix, is_int_const;
	int value;	// Still need this, to calculate constant values for matrix dimensions
	vector< vector<int> > matrix;
	int rows, cols;	// Need these (for matrix dimensions, obviously)
	string name;
	int stack_offset;	// For use in the symbol table, to find s[i]'s index
	
	// Not in use in the symbol table (nodes only):
	list<int> next_list, true_list, false_list;
	int buffer_offset;	// For use with SaveAddress
} STYPE;

#define YYSTYPE STYPE	// Tell Bison to use STYPE as the stack type

#endif
