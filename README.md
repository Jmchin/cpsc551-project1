# Project 1 -- Rinda
# Justin Chin (jmchin@csu.fullerton.edu)
# Daniel Miranda (dvspirate@csu.fullerton.edu)

## Starting with Rinda

These sets of files working in conjunction implement the functionality
as specified by the "Starting with Rinda" section in the project 1
document.

1. Initialize the Ruby TupleSpace

    ``` sh
       ruby tuplespace.rb
    ```

2. Initialize the client program

   ``` sh
      ruby blog.rb
   ```

---

In the terminal window where you ran *blog.rb*, you should see the
following output:

["bob", "distsys", "I am studying chap 2"]

["alice", "gtcn", "This graph theory stuff is not easy"]

["bob", "gtcn", "Cool book!"]

The above output is obtained by first having two users, bob and alice
write to the tuplespace, while a third user, Chuck, reads from the
tuplespace.

## Adapting Rinda to XML-RPC

These sets of files working in conjunctoins implement the
functionality as specified by the "Adapting Rinda to XML-RPC" section
in the project 1 document.

1. Initialize the Ruby TupleSpace

    ``` sh
       ruby tuplespace.rb
    ```


2. Initialize the adapter program

    ``` sh
       ruby adapter.rb
    ```

The adapter program registers two different handler classes, one for
the microblog functionality, and another for arithmetic, each
implementing their own interface to the Ruby TupleSpace.


## Using Rinda from Python

These sets of files working in conjunction allow python clients to
interop with a Ruby TupleSpace.

1. Initialize the Ruby TupleSpace

    ``` sh
        ruby tuplespace.rb
    ```

2. Initialize the adapter program

    ``` sh
       ruby adapter.rb
    ```

3. Initialize the blog client

    ``` sh
       python3 blog.py
    ```

---

In the terminal window where you ran *blog.py*, you should see the
following output:

["bob", "distsys", "I am studying chap 2"]

["alice", "gtcn", "This graph theory stuff is not easy"]

["bob", "gtcn", "Cool book!"]

The above output is obtained by first having two users, bob and alice
write to the tuplespace, while a third user, Chuck, reads from the
tuplespace. For convenience, all three of these operations are
contained inside a single file, however they can be split up into
three separate files which can be executed independently.

These sets of files working in conjunction allow python client to
Implement 'Next' functionality.

1. Initialize the Ruby TupleSpace

    ``` sh
        ruby tuplespace.rb
    ```

2. Initialize the adapter program

    ``` sh
       ruby adapter.rb
    ```

3. Initialize the blog client

    ``` sh
       python3 blog.py
    ```

4. Initialize the client (reader)

    ``` sh
       python3 next.py
    ```

---

In the terminal window where you ran *next.py*, you should see the
following output:

Enter 'n' for next blog post
Enter 'q' to quit

From here, the reader can provide a topic (channel) for which they'd
Like to search by first selecting option 'n'. If the channel they searched
exist, it will return the next post/content for that channel, otherwise
It will return 'Topic not found!' The user can continue searching using 
the 'n'option or choose to quit with 'q' 


These sets of files working in conjunction allow arithmetic operations
To be performed.

1. Initialize the Ruby TupleSpace

    ``` sh
        ruby tuplespace.rb
    ```

2. Initialize the adapter program

    ``` sh
       ruby adapter.rb
    ```

3. Initialize the arithmetic client

    ``` sh
       python3 arithmetic_client.py
    ```

4. Initialize the arithmetic server

    ``` sh
       python3 arithmetic_server.py
    ```

---

In the terminal window where you ran *arithmetic_client.py*, you should see the
following output:

wrote ["*", 2, 2] to TS 

The above will appear and begin waiting for the server to be initiated. Once the
server is initialized it will perform the operation and respond with a result.
Consequently, the next operation will be written to the tuplespace by the client
and the server will respond with result, so and and so forth until all are complete.
The following will be displayed.

wrote ["*", 2, 2] to TS
4 = 2 * 2
wrote ["+", 2, 5] to TS
7 = 2 + 5
wrote ["-", 9, 3] to TS
6 = 9 - 3



 

