package com.example.guestbook;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;

public class FindUser {
	static DatastoreService dataStore = DatastoreServiceFactory.getDatastoreService();
	
	public static Iterable<Entity> allProf(){
		
		Query query = new Query("Prof");
		PreparedQuery pq = dataStore.prepare(query);
		
		return pq.asIterable();
	}
	
	public static boolean getRoot(String userID){
		return userID.compareTo("root@kookmin.ac.kr") == 0;
	}
	
	public static void addProf(String userID){
		Entity person = new Entity("Prof", userID);
		dataStore.put(person);
	}
}
