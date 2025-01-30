from pyspark import SparkContext

if __name__ == "__main__":
    words = 'the quick brown fox jumps over the lazy dog the quick brown fox jumps over the lazy dog'
    seq = words.split()

    # Create SparkContext
    sc = SparkContext(appName="WordCount")

    # Perform word count
    data = sc.parallelize(seq)
    counts = data.map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b).collect()

    # Print the results
    print(dict(counts))

    # Stop the SparkContext
    sc.stop()
