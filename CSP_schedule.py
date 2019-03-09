import csp
from copy import deepcopy

class Problem(csp.CSP):

    def __init__(self, fh):
        # set variables, domains, graph, and constraint_function accordingly
        self.file = fh

        # Place to store the solution after backtracksearch; solution is a dict {var: val}
        self.solution = {}

        lines = []
        # Values for variables and domains
        T = []
        R = []
        S = []
        W = []
        A = []

        # Student and course dictionary; Key=Course and Value=list of students participating

        for line in self.file:
            lines.append(line)

        for i in lines:
            ip = i.split()
            if ip[0] == 'T':  # if T
                # Change values to tuples of two "," and remove first letter
                for i in ip[1:]:  # skip the first letter
                    t_tuple = i.split(',')
                    T.append(tuple(t_tuple))

            elif (ip[0] == 'R'):  # if R
                # Remove first R
                for i in ip[1:]:
                    R.append((i,))

            elif (ip[0] == 'S'):  # if S
                # Remove first S
                for i in ip[1:]:
                    S.append((i,))

            elif (ip[0] == 'W'):  # if W
                # Change values to tuples of three ","
                for i in ip[1:]:
                    w_tuple = i.split(',')
                    w_tuple[2] = int(w_tuple[2])  # changing from strign to int so that it is easier to compare
                    W.append(tuple(w_tuple))

            elif (ip[0] == 'A'):  # if A
                # change values to tuples of two
                for i in ip[1:]:
                    a_tuple = tuple(i.split(','))
                    A.append((a_tuple))
                    
        # latest time slot of the week
        latest_time_slot = 0
        for t in T:
            if int(t[1]) >= int(latest_time_slot):
                latest_time_slot = int(t[1])
                    
        self.W = W
        self.T = T
        self.R = R
        self.S = S
        self.A = A
        self.latest_time_slot = latest_time_slot

        self.student_dict = {}
        for i in range(0, len(A)):
            self.student_dict.setdefault(A[i][1], []).append(A[i][0])

        # Set variables
        variables = W

        # Set the domain list which is all the possible combinations of T x R [{day, time, place}, Doimains = [{day, time, place}, {day, time, place}, ...]
        domain_list = []
        for i in range(0, len(T)):
            for j in range(0, len(R)):
                domain_list.append(T[i] + R[j])

        # Set the domain for each variable
        domains = {}
        for i in range(0, len(W)):
            domains[W[i]] = domain_list

        # Set neighbors
        neighbors = {}
        for i in variables:
            var = deepcopy(variables)
            var.remove(i)
            neighbors[i] = var
          
        constraints = self.constraints

        super().__init__(variables, domains, neighbors, constraints)

    def constraints(self, A, a, B, b):

        if (a[0] == b[0]):  # if same day
            if (a[1] == b[1] and a[2] == b[2]):  # [1] if same time and same room
                return False

            if (A[0] == B[0]):  # [2] if same subject
                if (A[1] == B[1]):  # if same type of class
                    return False

            if (a[1] == b[1]):  # [3] if same time
                for i in self.student_dict[B[0]]:  # Go through the students in course B
                    for j in self.student_dict[A[0]]:  # Go through the students in course A
                        if (i == j):  # if same student types overlaps in these courses
                            return False
                            
        if int(a[1]) >= self.latest_time_slot: # if current timeslot is later then latest timeslot
            return False
            
        if int(b[1]) >= self.latest_time_slot:
            return False
            
        return True


    def dump_solution(self, fh):
        if self.solution != None:
            for k, v in self.solution.items():
                fh.write("%s,%s,%s %s,%s %s\n" % (k[0], k[1], k[2], v[0], v[1], v[2])) # k=[subject, w.c.type, numeber] v=[day, time, place]


def solve(input_file, output_file):
    p = Problem(input_file)

    # Place here your code that calls function csp.backtracking_search(self, ...
    I = p.latest_time_slot

    for i in range(I):
        prob = deepcopy(p)
        # reduce latest time slot by 1 with each iteration
        prob.latest_time_slot = I - i
        # new csp solution
        prob.solution = csp.backtracking_search(prob, csp.mrv, csp.unordered_domain_values, csp.forward_checking)
        if prob.solution is not None:
            # update solution
            p.solution = deepcopy(prob.solution)
            continue
        else:
            break

    p.dump_solution(output_file)