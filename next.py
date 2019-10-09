#!/usr/bin/python

# next.py

# implements note 2.3

from xmlrpc.client import ServerProxy, Error



def main():

    # main program loop
    with ServerProxy("http://localhost:8000", allow_none=True) as proxy:

        # initialize a map for all topics we have subscribed
        d = {}

        # pulls the 'next' associated tuple for topic
        def next(topic, counter):
            t = proxy.microblog._rd(None, topic, "String", counter)
            return t

        print("Enter 'n' for next blog post")
        print("Enter 'q' to quit")

        while True:

            key = input("")  # read key from user input
            key = ord(key[0])

            if key == ord('n'):
                topic = input("Topic: ")

                if topic not in d:
                    d[topic] = 1

                res = next(topic, d[topic])

                # if res:
                #     print(res)
                #     d[topic] += 1
                # else:
                #     print("No record found!")
                #     del d[topic]

                if res == "no-new-stories":
                    print(f'No new stories for \'{topic}\'')
                elif res == "topic-not-found":
                    print('Topic not found!')
                elif res:
                    print(res)
                    d[topic] += 1
                else:
                    print('Something went wrong!')

            if key == ord('q'):
                return


if __name__ == "__main__":
    main()
