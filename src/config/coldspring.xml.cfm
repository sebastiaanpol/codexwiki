<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE beans SYSTEM "spring-beans.dtd">
<beans default-autowire="byName">

	<!--Transfer Factory: PERSISTANCE MANAGED BY COLDSPRING -->
	<bean id="TransferFactory" class="transfer.TransferFactory" singleton="true" autowire="no">
		<constructor-arg name="datasourcePath">
			<value>${Transfer.datasourcePath}</value>
		</constructor-arg>
		<constructor-arg name="configPath">
			<value>${Transfer.configPath}</value>
		</constructor-arg>
		<constructor-arg name="definitionPath">
			<value>${Transfer.definitionPath}</value>
		</constructor-arg>
	</bean>

	<bean id="Transfer" factory-bean="TransferFactory" factory-method="getTransfer" />
	<bean id="Datasource" factory-bean="TransferFactory" factory-method="getDatasource" />
	<bean id="Transaction" factory-bean="TransferFactory" factory-method="getTransaction" />

	<!-- Transfer related beans -->

	<bean id="TDOBeanInjectorObserver" class="codex.model.transfer.TDOBeanInjectorObserver" lazy-init="false" />
	<bean id="BeanInjector" class="codex.model.util.BeanInjector" />
	<bean id="BeanPopulator" class="codex.model.transfer.BeanPopulator"/>

	<!-- ColdBox Related Beans -->

	<bean id="ColdboxFactory" class="coldbox.system.extras.ColdboxFactory" autowire="no" />

	<bean id="ColdBoxController" factory-bean="ColdBoxFactory" factory-method="getColdBox" />
	<bean id="InterceptorService" factory-bean="ColdBoxController" factory-method="getinterceptorService" />
	<bean id="ConfigBean" factory-bean="ColdBoxFactory" factory-method="getConfigBean" />
	<bean id="ColdboxOCM" factory-bean="ColdboxFactory" factory-method="getColdBoxOCM" />
	<bean id="sessionstorage" factory-bean="ColdboxFactory" factory-method="getPlugin">
		<constructor-arg name="plugin">
	       <value>sessionstorage</value>
	   </constructor-arg>
	</bean>

	<!-- wiki -->

	<bean id="WikiService" class="codex.model.wiki.WikiService" />

	<bean id="ConfigService" class="codex.model.wiki.ConfigService" />

	<!-- Parsers -->
	<bean id="WikiText" class="codex.model.wiki.parser.WikiText" />
	<bean id="Feed" class="codex.model.wiki.parser.Feed" />

	<!-- rss -->
	<bean id="RSSManager" class="codex.model.rss.RSSManager" />

	<!-- Security -->
	<bean id="SecurityService" class="codex.model.security.SecurityService">
		<property name="sessionstorage">
			<ref bean="sessionstorage"/>
		</property>
		<!--User service autowired-->
	</bean>
	<bean id="UserService" class="codex.model.security.UserService">
		<property name="HashType"><value>${HashType}</value></property>
	</bean>

	<!-- Lookups -->
	<bean id="LookupService" class="codex.model.lookups.LookupService" />


</beans>