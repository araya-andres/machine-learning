class Clusterer
  def self.cluster(data, nclusters = 3, maxit = 10)
    ntuples = data.length
    clustering = init_random(ntuples, nclusters)
    1.upto(maxit).each do
      clusters = get_clusters(clustering, data)
      centroids = get_centroids(clusters)
      new_clustering = update_clustering(data, centroids)
      break if new_clustering == clustering
      clustering = new_clustering
    end
    get_clusters clustering, data
  end
  
  # assigns a cluster randomly to each data tuple
  def self.init_random(ntuples, nclusters)
    k = (1.0 * ntuples / nclusters).ceil
    ((1..nclusters).to_a * k).shuffle.take(ntuples)
  end
  private_class_method :init_random
  
  # returns a hash with the data tuples clustered
  def self.get_clusters(clustering, data)
    clustering.zip(data).inject({}) do |h, x|
      (h[x.first] ||= []) << x.last
      h
    end
  end
  private_class_method :get_clusters
  
  # returns a hash with the centroid for every cluster
  def self.get_centroids(clusters)
    clusters.inject({}) do |h, (clusterId, values)|
      h[clusterId] = values.transpose.map { |x| x.reduce(:+) / x.length }
      h
    end
  end
  private_class_method :get_centroids
  
  # assigns the closer cluster to each data tuple
  def self.update_clustering(data, centroids)
    data.inject([]) { |ary, p| ary << closer_centroid(p, centroids) }
  end
  private_class_method :update_clustering
  
  # returns the id of the cluster with the closer centroid to p
  def self.closer_centroid(p, centroids)
    centroids.inject({}) do |h, (clusterId, centroid)|
      h[clusterId] = squared_distance p, centroid
      h
    end.min_by { |clusterId, squaredDistance| squaredDistance }.first
  end
  private_class_method :closer_centroid
  
  # Auxiliary functions
  
  # returns the squared distance from p to q
  def self.squared_distance(p, q)
    p.zip(q).map { |x| (x[0] - x[1])**2 }.reduce(:+)
  end
  private_class_method :squared_distance
end

__END__

rawData = [ [ 73.0, 72.6 ],
            [ 61.0, 54.4 ],
            [ 67.0, 99.9 ],
            [ 68.0, 97.3 ],
            [ 62.0, 59.0 ],
            [ 75.0, 81.6 ],
            [ 74.0, 77.1 ],
            [ 66.0, 97.3 ],
            [ 68.0, 93.3 ],
            [ 61.0, 59.0 ] ]
