/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.apache.pulsar.io.cassandra;

import java.io.IOException;

import org.apache.pulsar.client.api.schema.GenericObject;
import org.apache.pulsar.functions.api.Record;
import org.apache.pulsar.io.cassandra.dao.CassandraDao;
import org.mockito.Mockito;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

public class CassandraDaoTest {
	ObjectMapper mapper = new ObjectMapper();

	@org.junit.Before
	public void init() {

	}

	@org.junit.Test
	public void deleteRecordCassandra() throws IOException {
		Record<GenericObject> rec=Mockito.mock(Record.class);
		Mockito.doNothing().when(rec).ack();
		CassandraSinkConfig config = new CassandraSinkConfig();
		config.setKeyspace("target");
		config.setTableName("customers");
		config.setRoots("3.84.250.3:9042");
		config.setDcName("OSS-dc0");
		CassandraDao dao = new CassandraDao(config);
		ObjectNode node = mapper.createObjectNode();
		node.put("id", new Long(121));
		dao.deleteRecord(rec, node);
	}

	@org.junit.Test
	public void deleteRecordKeySpace() throws IOException {
		Record<GenericObject> rec=Mockito.mock(Record.class);
		Mockito.doNothing().when(rec).ack();
		CassandraSinkConfig config = new CassandraSinkConfig();
		config.setKeyspace("tutorialkeyspace");
		config.setTableName("customers");
		config.setRoots("cassandra.us-east-1.amazonaws.com:9142");
		config.setRegion("us-east-1");
		config.setKeyspacedb(true);
		CassandraDao dao = new CassandraDao(config);
		ObjectNode node = mapper.createObjectNode();
		node.put("id", new Long(121));
		dao.deleteRecord(rec, node);
	}
	
	@org.junit.Test
	public void deleteRecordKeySpaceWithConfigPath() throws IOException {
		Record<GenericObject> rec=Mockito.mock(Record.class);
		Mockito.doNothing().when(rec).ack();
		CassandraSinkConfig config = new CassandraSinkConfig();
		config.setConfigFilePath("config/cassandra-loader/application-keyspace-iamuser.conf");
		config.setKeyspace("tutorialkeyspace");
		config.setTableName("customers");
		config.setKeyspacedb(true);
		CassandraDao dao = new CassandraDao(config);
		ObjectNode node = mapper.createObjectNode();
		node.put("id", new Long(121));
		dao.deleteRecord(rec, node);
	}
	
	@org.junit.Test
	public void deleteRecordKeySpaceWithConfigPath2() throws IOException {
		Record<GenericObject> rec=Mockito.mock(Record.class);
		Mockito.doNothing().when(rec).ack();
		CassandraSinkConfig config = new CassandraSinkConfig();
		config.setConfigFilePath("config/cassandra-loader/application-keyspace-secret-manager.conf");
		config.setKeyspace("tutorialkeyspace");
		config.setTableName("customers");
		config.setKeyspacedb(true);
		CassandraDao dao = new CassandraDao(config);
		ObjectNode node = mapper.createObjectNode();
		node.put("id", new Long(121));
		dao.deleteRecord(rec, node);
	}
}