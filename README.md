# Project 1 -- Rinda

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
