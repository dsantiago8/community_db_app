--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    categoryid integer NOT NULL,
    name character varying(50)
);


--
-- Name: categories_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_categoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_categoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_categoryid_seq OWNED BY public.categories.categoryid;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    commentid integer NOT NULL,
    listingid integer NOT NULL,
    userid integer NOT NULL,
    content text NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: comments_commentid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_commentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_commentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_commentid_seq OWNED BY public.comments.commentid;


--
-- Name: listings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.listings (
    listingid integer NOT NULL,
    title character varying(100),
    description text,
    categoryid integer,
    locationid integer,
    creatorid integer,
    dateposted timestamp without time zone DEFAULT now(),
    eventdate date,
    viewcount integer DEFAULT 0 NOT NULL
);


--
-- Name: listings_listingid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.listings_listingid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: listings_listingid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.listings_listingid_seq OWNED BY public.listings.listingid;


--
-- Name: listingsignups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.listingsignups (
    signupid integer NOT NULL,
    listingid integer,
    userid integer,
    signupdate timestamp without time zone DEFAULT now()
);


--
-- Name: listingsignups_signupid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.listingsignups_signupid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: listingsignups_signupid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.listingsignups_signupid_seq OWNED BY public.listingsignups.signupid;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    locationid integer NOT NULL,
    name character varying(100)
);


--
-- Name: locations_locationid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_locationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_locationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_locationid_seq OWNED BY public.locations.locationid;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    messageid integer NOT NULL,
    senderid integer NOT NULL,
    receiverid integer NOT NULL,
    listingid integer NOT NULL,
    content text NOT NULL,
    sentat timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: messages_messageid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_messageid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_messageid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_messageid_seq OWNED BY public.messages.messageid;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    orgid integer NOT NULL,
    description text,
    website character varying(200)
);


--
-- Name: savedlistings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.savedlistings (
    userid integer NOT NULL,
    listingid integer NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    userid integer NOT NULL,
    name character varying(100),
    email character varying(100) NOT NULL,
    isorganization boolean DEFAULT false,
    createdat timestamp without time zone DEFAULT now(),
    passwordhash text DEFAULT ''::text NOT NULL
);


--
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;


--
-- Name: categories categoryid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN categoryid SET DEFAULT nextval('public.categories_categoryid_seq'::regclass);


--
-- Name: comments commentid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN commentid SET DEFAULT nextval('public.comments_commentid_seq'::regclass);


--
-- Name: listings listingid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listings ALTER COLUMN listingid SET DEFAULT nextval('public.listings_listingid_seq'::regclass);


--
-- Name: listingsignups signupid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listingsignups ALTER COLUMN signupid SET DEFAULT nextval('public.listingsignups_signupid_seq'::regclass);


--
-- Name: locations locationid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN locationid SET DEFAULT nextval('public.locations_locationid_seq'::regclass);


--
-- Name: messages messageid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN messageid SET DEFAULT nextval('public.messages_messageid_seq'::regclass);


--
-- Name: users userid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (categoryid, name) FROM stdin;
1	Events
2	Services
3	Goods
4	Jobs
5	Volunteering
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.comments (commentid, listingid, userid, content, createdat) FROM stdin;
1	131	10	Can Repair phones if needed	2025-04-29 20:30:20.141326
2	131	11	Thnx when available	2025-04-29 20:31:17.239004
3	131	10	New Comment 	2025-04-29 21:08:14.849144
4	132	10	New Commment	2025-04-29 21:12:30.052005
5	132	10	NEW NEW COmment\r\n	2025-05-02 00:55:25.472163
\.


--
-- Data for Name: listings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.listings (listingid, title, description, categoryid, locationid, creatorid, dateposted, eventdate, viewcount) FROM stdin;
5	Computer Science Fair	club meeting	1	1	4	2025-04-03 11:23:12.536003	\N	0
6	BioChem	fdd	1	1	5	2025-04-03 21:19:04.159495	\N	0
7	random	Desc\r\n	3	3	5	2025-04-03 21:19:24.86229	\N	0
8	hjgygg	jvvy	1	1	6	2025-04-03 22:37:50.16825	\N	0
9	Test	adte	1	1	7	2025-04-04 10:12:28.311071	\N	0
10	TEst2	Test Description	4	3	8	2025-04-04 10:26:18.907935	\N	0
11	Tester3	Tester2	2	3	8	2025-04-04 10:27:06.084233	\N	0
12	Tester 5	Tester 5 description	4	4	1	2025-04-04 11:59:44.699916	\N	0
13	Tester6	Crazy Volunteering Opportunity	5	6	1	2025-04-04 12:00:56.645798	\N	0
14	Tester 5	dfs	1	4	9	2025-04-07 22:48:12.914741	\N	0
15	Tester 5	dfs	1	1	1	2025-04-16 14:17:53.80896	\N	0
16	Tester 5	dfs	1	1	1	2025-04-16 14:18:09.124106	\N	0
17	Small Cotton Computer	Et debitis non tempora. Accusamus ipsum rerum pariatur ab similique culpa aperiam. Qui quo nostrum dicta. Et nobis magni et ratione. Necessitatibus ullam perferendis ipsa nihil voluptates nam nesciunt modi rerum.	1	3	2	2025-04-16 22:17:22.441096	\N	0
18	Rustic Soft Cheese	Quibusdam enim in voluptatem. In nostrum et. Est rerum similique tempore qui cupiditate eos. Et unde porro cumque est tempora consequatur et minus. Quae quia eos eum quia.	3	1	2	2025-04-16 22:17:22.484982	\N	0
20	Fantastic Steel Sausages	Maiores aut amet aut atque aut sapiente illo. Reiciendis ut quibusdam. Aut deserunt cupiditate saepe esse quia excepturi enim dolores quo. Rerum sint praesentium voluptatem corrupti.	1	1	1	2025-04-16 22:23:15.63014	\N	0
21	Handcrafted Plastic Pants	Sit quos facere blanditiis autem totam numquam qui doloremque. Veniam quod et distinctio enim exercitationem harum fugit quae. Placeat ipsum unde provident expedita. Dolor non laboriosam ipsa voluptas aut perferendis aperiam. Voluptatem rerum et.	3	1	2	2025-04-16 22:23:15.660992	\N	0
22	Fantastic Soft Bacon	Voluptatem doloremque cupiditate praesentium quis. Aut iure sed eius eligendi sit et. Totam nobis beatae impedit rerum illo. Molestiae enim est eligendi et. Iure natus eaque. Eveniet dolores quis mollitia.	1	2	1	2025-04-16 22:23:15.662509	\N	0
23	Intelligent Concrete Shirt	Aut aut aliquid doloribus consequatur quas quia inventore. Recusandae atque qui aut ipsa explicabo iste natus. Error est iusto fuga sunt a dolorem et. At porro ut nesciunt ullam aliquam quia molestias. Esse ipsa autem.	1	1	2	2025-04-16 22:23:15.663929	\N	0
24	Licensed Soft Towels	Nobis voluptate saepe veniam. Dicta fuga voluptas rerum ullam est placeat consectetur tempora. Illo quibusdam et aut consequuntur magni vitae ea. Eveniet consequatur explicabo fuga expedita distinctio eos.	1	3	2	2025-04-16 22:23:15.665999	\N	0
25	Awesome Soft Bike	Illo dolores sunt voluptates aut sint. Quisquam sunt non. Aut excepturi molestiae aut enim quia delectus et libero eaque. Mollitia repellendus quo. Modi et omnis dolorem illum dignissimos velit provident.	3	2	1	2025-04-16 22:23:15.667769	\N	0
26	Tasty Plastic Shirt	Est veniam officia iure nihil commodi repellendus ipsa. Sed vitae blanditiis saepe sed rerum incidunt nihil est rerum. Natus beatae qui voluptatem architecto nesciunt laudantium.	2	2	2	2025-04-16 22:23:15.669592	\N	0
27	Intelligent Soft Pizza	Non neque dolor. Minima ratione ea quidem harum. Quo quam repellendus quo occaecati vitae rerum qui.	2	1	1	2025-04-16 22:23:15.670886	\N	0
28	Small Concrete Bike	Cum dignissimos officia est autem. Praesentium aut eius qui aliquid hic et quo deleniti distinctio. Velit vero autem sint saepe animi et nihil voluptate et. Est sed fugiat rerum ipsum sunt vitae. Labore placeat vero laudantium qui. Ut culpa aliquam in et amet vel maiores enim iusto.	2	3	1	2025-04-16 22:23:15.672107	\N	0
29	Refined Concrete Shirt	Et dolores iusto voluptatem. Labore ratione culpa est nobis architecto. Omnis ut quos facere repudiandae. Eum aliquid corrupti earum sint nam dicta.	3	1	2	2025-04-16 22:23:15.673468	\N	0
30	Handcrafted Rubber Car	Ad labore officia aliquid voluptatem iure neque quas. Quae velit sint ad error veritatis asperiores impedit. Quibusdam aut enim dolores autem et placeat officiis. Nesciunt explicabo a eos cupiditate quia. Et inventore quia ad nostrum voluptas consectetur enim.	1	2	1	2025-04-16 22:23:15.67457	\N	0
31	Unbranded Granite Sausages	Voluptatum earum omnis amet. Accusantium autem nostrum sit aut quia aut. Sint vero et velit perferendis et. Veritatis quae omnis eos dolor est at. Commodi autem consequatur illum modi provident amet quo omnis dolor.	1	1	1	2025-04-16 22:23:15.675608	\N	0
32	Sleek Fresh Chips	Nostrum amet ad possimus quia aut autem id. Voluptatem pariatur maiores aut ut quis. Repellat et sequi id voluptate.	3	1	1	2025-04-16 22:23:15.676683	\N	0
33	Rustic Cotton Pizza	Doloribus minima maiores explicabo voluptas quod voluptas quidem animi. Consectetur beatae distinctio. Ab odio aperiam at id molestias est accusamus numquam. Voluptatibus et eum est animi maxime et in non voluptate. Soluta quas similique ea eos quis veniam corrupti ipsam commodi.	3	2	1	2025-04-16 22:23:15.678061	\N	0
34	Practical Soft Ball	Nihil est omnis et et maiores. Non quia et magni. A corrupti nisi. Dolorem nulla eos vero error amet. Et aut aspernatur aspernatur.	2	3	1	2025-04-16 22:23:15.679892	\N	0
35	Intelligent Metal Ball	Necessitatibus pariatur voluptates reprehenderit voluptatibus delectus neque. Occaecati voluptas molestiae. Et optio inventore commodi veniam est voluptas. Vel officiis quaerat illum. Quia totam deleniti. Architecto autem officia illo sit sapiente aliquid fugiat id.	3	3	1	2025-04-16 22:23:15.681339	\N	0
36	Rustic Concrete Shoes	Voluptas dolorem vel rerum. Officiis voluptate saepe enim. Beatae ex qui sed sed. Ipsum alias corrupti deserunt ea.	1	2	2	2025-04-16 22:23:15.682578	\N	0
37	Intelligent Concrete Soap	Inventore non dolores et. Fuga eum excepturi illum modi. Quisquam doloremque debitis dolorum laudantium. Quod libero nihil culpa qui. Non repellendus voluptatem. Omnis est quasi sed corrupti qui tempora.	1	1	2	2025-04-16 22:23:15.684069	\N	0
38	Fantastic Steel Sausages	Eveniet natus ut. Et debitis eligendi. Illo id provident sed aut voluptatem qui similique id similique. Eveniet pariatur sunt neque tenetur ea consectetur totam. Voluptatum non voluptatem iure unde qui rerum quidem numquam nobis. Ad et possimus nisi dolorem sed aut officiis.	3	1	1	2025-04-16 22:23:15.685565	\N	0
39	Tasty Metal Table	Non et veniam perferendis dolores soluta perferendis corporis iure nihil. Dolorem animi tempore mollitia aliquam. Omnis id sed. Veniam expedita accusantium iste est rem. Nesciunt harum eaque officiis velit neque et sunt aliquam reiciendis.	1	3	2	2025-04-16 22:23:15.686969	\N	0
68	Small Frozen Bike	Eum culpa ea qui harum voluptatem sit eligendi qui quo. Aut in qui et aut. Aut sequi tempora magnam occaecati et. Eius asperiores consequatur quae sed error aut quo. Quam vel et quisquam quod impedit rerum et ipsa.	3	2	1	2025-04-16 22:23:15.72505	\N	0
40	Incredible Cotton Gloves	Ut voluptas pariatur. Debitis eum qui nisi id. Rem eaque deserunt officiis mollitia repellat voluptatem et. Commodi a earum molestiae incidunt. Voluptatem voluptas voluptates nobis quibusdam autem. Porro necessitatibus velit quia nostrum non aut explicabo placeat.	1	2	1	2025-04-16 22:23:15.688426	\N	0
41	Incredible Metal Soap	Porro tempora ut ut asperiores deleniti earum vitae nihil sed. Qui quos ipsa. Soluta qui dolorum. Reprehenderit ullam nemo. Quia at expedita quo sit cum quas.	3	2	1	2025-04-16 22:23:15.692812	\N	0
42	Handcrafted Soft Pizza	Sapiente excepturi dicta ipsum ullam. Facere nisi vero ullam. Dolorem ullam magni voluptatum et et sed sequi similique.	2	3	2	2025-04-16 22:23:15.693845	\N	0
43	Gorgeous Frozen Chips	Error voluptate consequatur possimus. A eos nihil nostrum deleniti ab quia libero libero. Quia labore quo ut harum necessitatibus odit. Aut et perspiciatis aperiam qui. Dolorem architecto eum in odit soluta aut eius aut.	2	1	1	2025-04-16 22:23:15.6949	\N	0
44	Tasty Wooden Shirt	Et consequatur vel cumque eum voluptas ipsum. Sed nisi accusantium enim. Labore repellat voluptas. Ullam eveniet quae adipisci.	3	3	1	2025-04-16 22:23:15.695961	\N	0
45	Intelligent Plastic Bike	Veritatis enim aut. Enim quis sunt dicta neque officiis deleniti omnis et. Aut officia nulla enim illo natus recusandae. Non unde sit ipsam laudantium est cumque tempora eum rerum. Aperiam corrupti odit sint ut voluptate. Consequatur distinctio non ut commodi nisi quidem libero aut est.	1	2	1	2025-04-16 22:23:15.697498	\N	0
46	Refined Soft Salad	Et dolores suscipit adipisci aut dolorum voluptatem qui. Eius voluptatibus exercitationem. Dolorem laboriosam sed maxime alias quibusdam cum eligendi. Voluptatem eius earum. Quia repudiandae rem consequatur nemo est et nihil sit voluptatum.	2	1	1	2025-04-16 22:23:15.698831	\N	0
47	Handmade Concrete Car	Fuga facere voluptas. Perferendis ut eos harum aliquam veniam ipsa ut placeat illum. Aut accusamus dolores ut aut ut temporibus. Quos qui eaque perspiciatis eaque fuga explicabo ut repellat. Dolorem doloremque ut rerum.	2	3	1	2025-04-16 22:23:15.700206	\N	0
48	Fantastic Rubber Chips	Dolore molestias quas aliquid et. Reiciendis in repudiandae praesentium expedita deserunt. Eaque nisi nesciunt sunt delectus nisi quasi ut dicta.	2	3	1	2025-04-16 22:23:15.70181	\N	0
49	Handmade Wooden Towels	Nam expedita velit enim hic voluptatem consectetur. Reprehenderit in necessitatibus provident non quaerat eaque ea dolor aut. Voluptatum ducimus exercitationem id assumenda officiis qui sit. Voluptatum est officiis adipisci.	3	1	1	2025-04-16 22:23:15.703126	\N	0
50	Handmade Wooden Shirt	Eligendi velit odio eius. Veniam corrupti consectetur sunt aut voluptatem et et. Laborum suscipit exercitationem voluptates magnam omnis placeat magni odit.	1	3	2	2025-04-16 22:23:15.704512	\N	0
51	Practical Frozen Bacon	Ut hic minus. Quisquam assumenda rem sit rerum incidunt qui eos. Hic dignissimos nemo quia aliquid qui. Vitae odit excepturi velit sint omnis.	3	2	1	2025-04-16 22:23:15.705627	\N	0
52	Rustic Fresh Salad	Qui numquam ducimus pariatur est dolorem maiores. Magni esse unde et enim voluptatem a voluptatem voluptatem excepturi. Corporis cumque in magni quis aut.	2	3	2	2025-04-16 22:23:15.706792	\N	0
53	Tasty Soft Fish	Vitae maiores ut. Aut neque quia vel. Tempora at aperiam asperiores sit quo nostrum iste maxime. Ipsam et omnis voluptate corrupti. Consequatur praesentium consectetur voluptatem dignissimos et sit odit consequatur.	3	1	1	2025-04-16 22:23:15.70791	\N	0
54	Ergonomic Steel Bike	Aut sint officiis. Dolor necessitatibus ea voluptate nisi sint odio consequatur. Necessitatibus corporis aliquam voluptas exercitationem expedita blanditiis quia dolorem aut. Debitis sed dolorum nam nostrum omnis. Dolore vel nihil nobis magni non impedit sint voluptates in.	2	2	2	2025-04-16 22:23:15.70896	\N	0
55	Generic Steel Gloves	Qui quidem odio et corrupti deleniti doloremque temporibus voluptatem fugiat. Et voluptas recusandae. Mollitia ipsum rerum porro itaque soluta voluptatibus molestias modi quis.	3	2	2	2025-04-16 22:23:15.709953	\N	0
56	Rustic Frozen Shoes	Est impedit qui. Distinctio dolor ipsum vel animi aut sint corrupti voluptatem. Molestias non aut dicta asperiores molestiae. Sint occaecati deleniti.	2	2	1	2025-04-16 22:23:15.710914	\N	0
57	Tasty Steel Bike	Praesentium nulla in. Eum repudiandae temporibus voluptatem possimus qui magnam minus. Ut et dolorem in ut ut sint dolorem. Aperiam quas quisquam sunt corporis. Mollitia dolorem fugit facere magni illum. Voluptatem et rerum quibusdam aut voluptas et.	2	1	1	2025-04-16 22:23:15.711892	\N	0
58	Fantastic Metal Cheese	Sed rem illo sint et. Est minus et cum. Laborum sit sapiente praesentium mollitia qui voluptas. Id in eos quas iusto doloremque.	3	1	1	2025-04-16 22:23:15.712828	\N	0
59	Ergonomic Metal Bacon	Maxime dolor unde qui doloremque similique sunt. Veritatis et consectetur maxime et. Recusandae similique ullam et voluptatem corrupti sequi repellendus. Doloremque eligendi debitis perferendis recusandae iure. Quas nemo sit earum quia nam aut aut. Labore fuga sed voluptatibus.	1	2	1	2025-04-16 22:23:15.713946	\N	0
60	Handcrafted Steel Sausages	Nihil repellendus suscipit et. Voluptas animi corrupti at dolor. Qui amet velit facere nihil eos omnis. Nulla velit ipsum harum eum dolor esse ut in in.	1	3	1	2025-04-16 22:23:15.715336	\N	0
61	Handcrafted Plastic Table	Atque dicta nostrum quibusdam velit rerum illum delectus. Sint iure adipisci sit itaque commodi. Dolorum occaecati porro rerum facere facilis dolore corporis quos dolorem. Ipsam qui amet quo quod dignissimos impedit asperiores et sed.	1	3	1	2025-04-16 22:23:15.716693	\N	0
62	Rustic Plastic Bacon	Doloremque maiores eius rerum debitis quia asperiores mollitia sunt aliquam. Architecto ut ipsam aut culpa non ea. A iste sit autem non nihil rem laudantium.	1	2	2	2025-04-16 22:23:15.718057	\N	0
63	Handmade Wooden Computer	Necessitatibus ut dolor minus omnis voluptate occaecati vel placeat et. Quasi voluptates eligendi voluptatem et. Maxime placeat accusamus nihil sunt occaecati. Voluptatum atque inventore quidem maiores maxime sit perspiciatis et exercitationem.	2	1	2	2025-04-16 22:23:15.719197	\N	0
64	Ergonomic Plastic Pizza	Natus minima perferendis quo. Ipsam eligendi accusantium possimus rem ipsa aut consequatur. Explicabo rerum accusamus voluptatibus sit voluptas numquam dolores earum. Fugiat libero ad eos. Aperiam repudiandae quia consectetur quo voluptate nemo possimus totam.	3	1	2	2025-04-16 22:23:15.720368	\N	0
65	Handmade Concrete Shoes	Vitae voluptate voluptatem illo accusamus culpa delectus. Atque iste aut ea nisi error. Aut facilis facere aut et ex. Saepe et quos consequatur alias ut esse.	1	2	1	2025-04-16 22:23:15.721488	\N	0
66	Unbranded Granite Car	Voluptatem velit fuga nihil labore mollitia voluptates provident. A deserunt officiis corrupti sunt dolores deserunt et et sequi. Nesciunt ab beatae repudiandae ut distinctio accusantium sequi. Fuga inventore libero voluptas blanditiis. Aspernatur sed laboriosam laboriosam aut mollitia fugiat vel cupiditate magnam. Vel ut ratione sed rerum officia.	1	1	1	2025-04-16 22:23:15.722586	\N	0
67	Generic Soft Salad	Alias sit architecto voluptates. Optio doloribus id voluptatum vitae voluptas ea. Et quibusdam ut pariatur iste in et.	1	1	2	2025-04-16 22:23:15.723897	\N	0
130	WORKING SAVE CHANGES BUTTON	Testing Save Changes	5	6	1	2025-04-18 23:33:26.241676	2025-08-28	3
69	Unbranded Soft Ball	Itaque tenetur ut quis inventore voluptas nihil. Quia aut vel reprehenderit eveniet sint dolores qui. Facilis dolores ut atque sed. Eius minus enim repellendus doloremque laudantium totam id quasi. Et quae itaque ut officiis et.	2	3	2	2025-04-16 22:23:15.726181	\N	0
70	Fantastic Frozen Towels	Sit rem at qui quibusdam facilis blanditiis incidunt nihil. Voluptas inventore perspiciatis repellat. Aut consequuntur eaque iusto omnis occaecati. Id perferendis doloremque rerum rerum. Deleniti molestiae saepe porro natus rerum qui magni.	3	2	1	2025-04-16 22:23:15.727486	\N	0
71	Incredible Soft Chair	Eos dignissimos culpa magni incidunt. Nemo laudantium ut praesentium a. Ex iusto debitis placeat itaque quisquam.	3	3	2	2025-04-16 22:23:15.728488	\N	0
72	Ergonomic Rubber Shirt	Consequatur qui error delectus facere placeat aliquam eum non. Omnis tenetur qui laboriosam alias consequatur non dolores consectetur sed. Laudantium laudantium accusantium earum et totam est similique voluptatem sit.	3	2	2	2025-04-16 22:23:15.729449	\N	0
73	Handmade Wooden Tuna	Vel ullam explicabo voluptates rerum harum odio eius temporibus. Nobis ex sapiente quos. Voluptatem ipsam suscipit quas quo eaque necessitatibus excepturi commodi quia. Sit eveniet minus qui laboriosam et. Qui aut voluptatem repellendus maxime quos.	3	3	2	2025-04-16 22:23:15.730373	\N	0
74	Gorgeous Fresh Shoes	Adipisci itaque perferendis autem. Tempore nihil alias nihil aut. Reiciendis optio qui reiciendis. Aspernatur laudantium animi modi qui ducimus aliquam laudantium.	2	3	1	2025-04-16 22:23:15.731753	\N	0
75	Tasty Concrete Table	Neque eos dolor. Corrupti impedit et voluptas. Minus dolore sit non. Optio ex magnam officia eos qui dicta delectus. Sit debitis enim commodi odit.	2	1	2	2025-04-16 22:23:15.733031	\N	0
76	Licensed Metal Hat	Ipsam quas suscipit cupiditate nam ut est. Tenetur ut veniam quia. Est praesentium est est omnis omnis ea. Rem atque ipsam atque facere dolores dolor exercitationem nihil fugiat. Odio rerum deserunt repellendus. Sed illum consectetur dolores tempora ipsa quidem cupiditate.	3	3	2	2025-04-16 22:23:15.734372	\N	0
77	Intelligent Rubber Towels	Consequatur eos sint adipisci quod velit inventore voluptate ea. Qui pariatur voluptatem voluptatem itaque praesentium fugiat eius. Veritatis id nihil. Quia quibusdam corporis quis eaque sit. Officia dolorem quia.	1	1	1	2025-04-16 22:23:15.73581	\N	0
78	Sleek Plastic Computer	Tenetur id quia vitae repellat. Non quae atque qui sit expedita. Sint quam repudiandae sapiente sequi dolorem.	3	2	2	2025-04-16 22:23:15.737004	\N	0
79	Tasty Wooden Tuna	Sed voluptatem cumque eligendi non quia alias dignissimos eos maiores. Non quisquam sed non facere. Earum explicabo eveniet quis sint totam mollitia culpa dolore.	3	3	2	2025-04-16 22:23:15.738345	\N	0
80	Practical Rubber Ball	Natus tempora velit vel dolore repudiandae dolorum et. Ut iusto ut illum eligendi rerum. Officiis et sit sed. Ut praesentium qui ab quia. Sed qui ut aut minima repellat veniam.	3	2	2	2025-04-16 22:23:15.739339	\N	0
81	Ergonomic Soft Pizza	Debitis corrupti sit eaque officiis numquam ex voluptatibus eos. Labore cupiditate aut labore sunt tenetur. Modi aliquid enim fugit eligendi neque iste.	3	1	2	2025-04-16 22:23:15.740318	\N	0
82	Rustic Frozen Towels	Perferendis adipisci repudiandae. Nemo possimus perspiciatis et esse quia neque aut. Voluptate dolores saepe sequi est ut et eum reprehenderit. Incidunt ut sit adipisci quo reprehenderit tenetur praesentium est reiciendis.	1	2	2	2025-04-16 22:23:15.74128	\N	0
83	Intelligent Frozen Fish	Incidunt magnam assumenda earum qui quaerat itaque repudiandae. Fugit consequatur quas iure possimus provident asperiores expedita corporis. Expedita rerum voluptatem voluptatibus qui tempora quaerat pariatur corporis ut. Occaecati omnis adipisci error aliquid enim vel hic.	3	3	1	2025-04-16 22:23:15.742302	\N	0
84	Sleek Metal Fish	Optio vel ipsum. Perspiciatis sint facilis beatae exercitationem voluptas. Rerum quaerat facere qui tempora sed quam consequatur rerum eum. Recusandae iste qui esse corporis necessitatibus ratione. Commodi est vero qui asperiores aliquam iure dolorem vel culpa. Est aut consequuntur dolorem nostrum laborum.	1	1	1	2025-04-16 22:23:15.743281	\N	0
85	Handmade Frozen Bike	Incidunt totam et unde et ut. Quia aliquam est nobis explicabo consequatur voluptatum ipsum. Ipsa adipisci ut ad eveniet veniam pariatur. Quia omnis voluptates in corrupti perspiciatis. Quas sed exercitationem.	3	2	2	2025-04-16 22:23:15.744204	\N	0
86	Gorgeous Soft Bike	Et molestiae in est et et voluptatem cum. Recusandae voluptatem praesentium aut ullam dolorem. Unde voluptatem quibusdam dolor rem. Nobis vero provident numquam suscipit.	2	2	2	2025-04-16 22:23:15.745146	\N	0
87	Handmade Frozen Ball	Et numquam nam est quia magni itaque labore dicta accusamus. Eligendi quia consequuntur expedita et fuga minima aut iure laboriosam. Hic quasi omnis molestiae et ea facilis ipsa voluptatem ullam. Facere eius ipsum ut omnis quisquam rerum culpa aut.	3	1	2	2025-04-16 22:23:15.746112	\N	0
88	Fantastic Steel Bacon	Mollitia dolor magnam. Sit sed eius. Vero voluptatem est qui atque aliquid consequuntur. Dolorem aut veniam ea quibusdam similique et itaque nostrum. Non quo odio atque. Quos mollitia reiciendis qui sint quia minima quia consequatur quo.	1	2	2	2025-04-16 22:23:15.747363	\N	0
89	Small Granite Computer	Officia similique cumque est consequatur qui. Dolorum qui voluptatum officiis ducimus dolor eos praesentium a. Et excepturi fugiat fugiat quae voluptatem libero dolorum. Dignissimos in tenetur laboriosam.	3	1	1	2025-04-16 22:23:15.748804	\N	0
90	Unbranded Cotton Bike	Et porro qui voluptas voluptates cupiditate sit aut. Libero laboriosam modi hic. Nam est rerum veritatis officiis nulla possimus adipisci modi. Nemo a ea consequuntur qui.	3	3	1	2025-04-16 22:23:15.750021	\N	0
91	Refined Frozen Pants	Eos assumenda officiis ut similique quisquam. Et autem saepe quod nam aspernatur ipsum et. Assumenda totam nostrum quas sed odio sed aliquam deleniti est. Veritatis et aut reprehenderit eius quasi reprehenderit quam explicabo eum.	3	2	2	2025-04-16 22:23:15.751141	\N	0
92	Handmade Granite Gloves	Rerum incidunt dicta omnis ut officiis omnis. Consequuntur quasi totam voluptas ipsa est. A ea occaecati cumque aperiam nemo ratione est repellat. Sed deleniti rerum facilis animi fugiat voluptatem eos excepturi. Unde aspernatur qui et. Quo nesciunt aliquid eius.	1	2	2	2025-04-16 22:23:15.752187	\N	0
93	Ergonomic Wooden Pizza	Deleniti modi iure labore voluptatem. Aliquam magni veritatis perspiciatis consectetur voluptas eius. Suscipit praesentium dolor reprehenderit qui tempore quis excepturi quisquam corrupti. Qui unde aut nobis qui ab ipsa quaerat quia quam. Id officiis blanditiis esse dolor pariatur ratione quis eos soluta. Aut cumque rerum veritatis debitis nobis esse consectetur et.	2	3	1	2025-04-16 22:23:15.753262	\N	0
94	Refined Concrete Gloves	Ipsa libero molestias ut. Et eum qui qui magni sint totam ut explicabo quo. Quo ex tempore laboriosam. Blanditiis asperiores nam numquam voluptatem ut facere quidem fugiat qui. Dolorem voluptatem provident id. Quod explicabo quisquam itaque placeat aut excepturi qui error.	1	3	1	2025-04-16 22:23:15.754207	\N	0
95	Generic Metal Tuna	Velit est architecto aspernatur voluptate. Voluptatem eum atque quidem corporis consequatur recusandae ducimus sed. Non ipsam ut voluptatum in.	3	1	2	2025-04-16 22:23:15.755343	\N	0
96	Awesome Frozen Hat	Eveniet magnam quia voluptates adipisci repudiandae beatae rerum dignissimos. Quam cupiditate fugit ipsam. Velit vel ut ratione reiciendis quia magnam consequuntur similique. Ut magnam est.	3	2	2	2025-04-16 22:23:15.756572	\N	0
97	Ergonomic Steel Keyboard	Dolorum esse aut necessitatibus nisi rerum aut nulla. Explicabo aut ad cupiditate. Nihil est accusantium. Corrupti ullam aperiam dolorum sint voluptatem voluptatum modi. Neque sit sapiente eligendi quasi fuga amet odio.	3	1	2	2025-04-16 22:23:15.75777	\N	0
98	Unbranded Metal Car	Atque aspernatur ut voluptates cumque quisquam id quas ab possimus. Aliquid laudantium architecto nisi assumenda omnis. Ut id aut minus nisi et. Facilis ut aut sunt laboriosam.	3	3	2	2025-04-16 22:23:15.758797	\N	0
99	Handcrafted Steel Pizza	Assumenda enim beatae excepturi et aliquam. Sequi consequatur qui officia. Doloremque magni dignissimos facere dolore impedit. Aut dolor necessitatibus ut animi minus.	1	3	1	2025-04-16 22:23:15.759705	\N	0
100	Practical Rubber Pants	Nam itaque eum voluptatum nesciunt earum distinctio omnis adipisci. Illo atque unde labore dolorum nostrum eum ut sunt. Sit aut qui sit ea tempore amet voluptatibus consequatur impedit. Fuga iste aliquam laborum nam laboriosam voluptatem non vitae. Ut aut officiis ut recusandae vitae libero. Rerum et vel perspiciatis sunt quis fugit.	1	3	2	2025-04-16 22:23:15.760591	\N	0
101	Handmade Metal Chips	Nihil quasi cum voluptate dolor voluptas eaque facilis nulla alias. Harum quibusdam quo tenetur est itaque veritatis consequatur omnis. Voluptas blanditiis temporibus ut est et officiis. Non quibusdam quas. Dolore debitis architecto voluptatibus doloremque ipsam iusto fuga accusamus ipsam.	3	2	2	2025-04-16 22:23:15.761457	\N	0
102	Awesome Plastic Ball	Qui modi ut nemo et. Autem dolor enim quam qui molestias odit nemo. Officiis non vero aut qui inventore. Est voluptas in libero nesciunt autem itaque architecto ipsum. Perferendis incidunt tempora et ut voluptates. Autem dolorum blanditiis accusantium atque quibusdam.	3	1	2	2025-04-16 22:23:15.762326	\N	0
103	Handmade Rubber Sausages	Iste dolor dolorem aut cupiditate. Magnam sit enim similique ut quia saepe voluptas. Accusantium labore sint voluptas sit consequatur. Ex in dolor. Sed aut nihil tenetur qui alias eius et. Voluptas rem nam assumenda adipisci molestiae illo mollitia ea autem.	1	3	1	2025-04-16 22:23:15.763245	\N	0
104	Intelligent Plastic Cheese	Voluptates eos omnis. Vel ea ex corrupti quas voluptatibus voluptatem nihil sed. Ipsa quisquam accusantium consequatur non odio. Corporis ab quod reiciendis error sit sunt culpa est sed. Quia perspiciatis deleniti dolorem architecto qui sint. Sunt aut dolor quia ut itaque illum veniam saepe.	3	3	2	2025-04-16 22:23:15.764478	\N	0
105	Handcrafted Concrete Cheese	Et fugiat reiciendis minus in rerum laboriosam sint. At odit molestiae quia dolorem rerum deserunt id eos iure. Exercitationem ad iure ipsa. Quia sit cumque illo perspiciatis id facere nisi ea iste. Sunt eum unde nisi ut voluptates doloribus et. Minima quia sit magnam.	2	2	2	2025-04-16 22:23:15.765899	\N	0
106	Handcrafted Frozen Gloves	A et reiciendis voluptatem repudiandae atque ratione. Vitae nostrum fuga illum sit et. Enim perspiciatis necessitatibus esse et ea ratione eligendi qui. Ut quo fugit cupiditate est quos iste pariatur dolorum ipsam.	3	3	2	2025-04-16 22:23:15.767485	\N	0
107	Handcrafted Granite Tuna	Est ut quisquam. Tempora perspiciatis repudiandae dolorum id voluptatibus unde odit veniam. Excepturi natus totam sit dignissimos aut est. Aperiam eius eveniet unde dolores in qui.	2	2	1	2025-04-16 22:23:15.769173	\N	0
108	Sleek Frozen Hat	Voluptatem provident nesciunt praesentium corrupti nulla nostrum aliquam. Aut sequi modi expedita et dolores. Et nostrum nihil dignissimos placeat rerum. Quam et modi nihil. Quae occaecati eius ut repudiandae praesentium debitis saepe.	1	1	1	2025-04-16 22:23:15.770717	\N	0
109	Licensed Fresh Hat	Atque unde dolor veritatis rerum. Quis repellendus odio saepe et libero amet. Ad debitis quae quis quod perferendis aspernatur tenetur aut ex.	2	1	1	2025-04-16 22:23:15.772322	\N	0
110	Licensed Frozen Pizza	Explicabo doloremque ut atque aut. Earum ratione facilis eaque libero laborum laboriosam. Sit dolore perspiciatis saepe illo et aut. Libero sint reprehenderit et omnis sunt id aliquid voluptas hic. Vitae enim sint error similique deleniti nulla quia.	2	2	1	2025-04-16 22:23:15.773889	\N	0
111	Intelligent Concrete Sausages	Neque doloribus reiciendis dolor nobis quasi expedita ut incidunt voluptatem. Et reprehenderit sed earum quas voluptatibus sit aut ut. Sunt dolor dignissimos et est repellat quia. Commodi placeat non voluptate necessitatibus consequuntur ex. Ullam id ducimus debitis eos omnis est officia. Id illo ut veniam consequatur.	2	3	1	2025-04-16 22:23:15.775491	\N	0
112	Generic Frozen Salad	Qui magnam qui sunt rem officia eum eius omnis vero. Veritatis iusto repudiandae dolores. Nobis sequi accusantium.	2	1	2	2025-04-16 22:23:15.77664	\N	0
113	Handcrafted Fresh Chicken	Consequatur autem aspernatur. Qui natus nesciunt perspiciatis excepturi assumenda. Nostrum et id voluptatem repellendus aperiam vero veniam nesciunt quibusdam.	3	3	2	2025-04-16 22:23:15.777889	\N	0
114	Small Granite Cheese	Qui ea distinctio. Fugit reprehenderit corrupti eos sit omnis sed quas. Atque doloribus harum dolore. Velit ea iusto quo voluptatum officia deserunt quod minus. Ullam molestias voluptas quis corporis consequuntur non quis asperiores. Et accusamus perspiciatis animi natus deserunt enim qui et excepturi.	1	1	1	2025-04-16 22:23:15.779175	\N	0
115	Rustic Soft Hat	Vel molestiae voluptas ex minima unde quia dolorem quod eos. Ut dignissimos doloribus quis consectetur in quod. Perferendis omnis voluptate repellendus sed in dolore. Suscipit voluptatem quis quia officiis cum distinctio iste expedita.	3	3	2	2025-04-16 22:23:15.780397	\N	0
116	Awesome Soft Car	Fugit tempora sed ut rem est. Eaque dolorem doloribus et. Blanditiis laborum cupiditate dolor quos eveniet rerum error officiis. Et aliquam suscipit.	3	3	2	2025-04-16 22:23:15.782039	\N	0
117	Unbranded Rubber Table	Error non unde nemo voluptatem similique neque ipsum. Consectetur incidunt blanditiis eos accusamus provident sint libero cum. Est laborum nam quaerat sapiente.	1	2	1	2025-04-16 22:23:15.78343	\N	0
118	Unbranded Rubber Shirt	Laudantium dolores natus. Quis laborum aut. Aliquid eligendi qui occaecati. Tenetur pariatur repellat aut commodi repellendus cupiditate sit at. Aut totam quae magnam totam enim aliquid rerum excepturi.	3	1	1	2025-04-16 22:23:15.784764	\N	0
119	Unbranded Cotton Chips	Enim hic quos consequatur ut culpa sit. Aut illum a. Iste id quia. Laborum dolorem numquam nihil nihil.	2	3	2	2025-04-16 22:23:15.785936	\N	0
120	EventDate Test	Testing EventDate 	2	3	1	2025-04-16 23:14:44.928766	\N	0
121	EventDate Test 2	EventDate Test 	1	6	1	2025-04-16 23:29:08.056001	\N	0
122	EventDate Test 3	Test 3\r\n	3	4	1	2025-04-16 23:37:05.17001	2025-04-30	0
123	EventDate Test 4	Test 4	1	1	1	2025-04-17 00:09:55.512835	2025-04-30	0
124	NewTEst	New Test	5	5	1	2025-04-17 10:52:25.961002	2025-04-17	0
125	Event Date Test	dsfdfsdf	1	1	1	2025-04-17 11:01:16.691277	2025-04-25	0
126	Final Test Hopefullu	Final Plz	1	1	9	2025-04-18 15:01:39.008784	2025-04-23	0
127	Final FInal	FInal	1	1	9	2025-04-18 15:01:50.381304	\N	0
131	Iphone Needed	Phone Screen Replacement Iphone X	2	4	11	2025-04-29 19:36:21.896395	\N	6
129	Event Date Testing	kgkfpodo	3	3	1	2025-04-18 23:33:00.437068	\N	2
128	Testing Final Event Date	mfklmvk	1	1	1	2025-04-18 23:11:47.893256	2025-04-26	3
132	Tryig it out	dfdsfds	1	1	10	2025-04-29 21:08:38.376081	\N	12
\.


--
-- Data for Name: listingsignups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.listingsignups (signupid, listingid, userid, signupdate) FROM stdin;
8	14	9	2025-04-16 14:09:37.882008
9	13	9	2025-04-16 14:09:41.971717
11	13	1	2025-04-16 14:12:52.177056
15	129	1	2025-04-23 16:03:39.437526
17	130	9	2025-04-24 13:58:43.727086
18	129	9	2025-04-24 13:58:47.273233
19	128	9	2025-04-24 13:58:51.724951
20	130	1	2025-04-24 19:44:48.321757
23	132	10	2025-05-02 00:55:06.16732
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.locations (locationid, name) FROM stdin;
1	Eagle Rock
2	Highland Park
3	Occdiental College
4	Occidental College- Academic Quad
5	Occidental COllege- Thorne Hall
6	Glendale
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.messages (messageid, senderid, receiverid, listingid, content, sentat) FROM stdin;
2	11	10	131	Replied	2025-05-02 03:23:51.485915
3	10	11	131	Replied to the reply	2025-05-02 03:24:25.221269
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.organizations (orgid, description, website) FROM stdin;
\.


--
-- Data for Name: savedlistings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.savedlistings (userid, listingid) FROM stdin;
10	131
10	132
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (userid, name, email, isorganization, createdat, passwordhash) FROM stdin;
1	Diego 	dsantiago@oxy.edu	f	2025-04-03 11:12:45.191368	
2	Naomi	nyaomi@oxy.edu	f	2025-04-03 11:17:18.226259	
4	Diego 	dsantiago@oxy.ed	f	2025-04-03 11:23:04.034631	
5	Cady	ca@oxy.edu	f	2025-04-03 21:18:47.971735	
6	Naomi	cttygyj	f	2025-04-03 22:37:44.592129	
7	iifiekoiw	dfakdidk@dfsidfo.com	f	2025-04-04 10:12:13.470736	
8	Tester	tester@gmail.com	f	2025-04-04 10:26:04.243762	
9	Tester 5	tester5@gmail.com	f	2025-04-04 10:39:06.959173	
11	Adam	adam@oxy.edu	f	2025-04-29 18:34:10.525476	$2a$11$KS/B2VmaTwiNDS3C7w6ew.3FoRryF/u38UQ0G.ILLpa5xGZffH1R2
10	Auri	auri-ruiz@oxy.edu	f	2025-04-28 23:30:38.095137	$2a$11$0Bn/IJ/xiB45WF42FCOY/u9EGB5rJy.mNPPUqfqoXYA9aawIpZMQW
12	cadence	wanner@oxy.edu	f	2025-04-30 23:18:59.177974	$2a$11$kgwnmhx6LvfTzlzie0rKyOKLq4MfrZjVUYSlg9YmJ.9OD2Q25Ufy.
\.


--
-- Name: categories_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_categoryid_seq', 5, true);


--
-- Name: comments_commentid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.comments_commentid_seq', 5, true);


--
-- Name: listings_listingid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.listings_listingid_seq', 132, true);


--
-- Name: listingsignups_signupid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.listingsignups_signupid_seq', 23, true);


--
-- Name: locations_locationid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.locations_locationid_seq', 6, true);


--
-- Name: messages_messageid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.messages_messageid_seq', 3, true);


--
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_userid_seq', 12, true);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (categoryid);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (commentid);


--
-- Name: listings listings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_pkey PRIMARY KEY (listingid);


--
-- Name: listingsignups listingsignups_listingid_userid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listingsignups
    ADD CONSTRAINT listingsignups_listingid_userid_key UNIQUE (listingid, userid);


--
-- Name: listingsignups listingsignups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listingsignups
    ADD CONSTRAINT listingsignups_pkey PRIMARY KEY (signupid);


--
-- Name: locations locations_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_name_key UNIQUE (name);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (locationid);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (messageid);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (orgid);


--
-- Name: savedlistings savedlistings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.savedlistings
    ADD CONSTRAINT savedlistings_pkey PRIMARY KEY (userid, listingid);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- Name: comments comments_listingid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_listingid_fkey FOREIGN KEY (listingid) REFERENCES public.listings(listingid) ON DELETE CASCADE;


--
-- Name: comments comments_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid) ON DELETE CASCADE;


--
-- Name: listings listings_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.categories(categoryid);


--
-- Name: listings listings_creatorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_creatorid_fkey FOREIGN KEY (creatorid) REFERENCES public.users(userid);


--
-- Name: listings listings_locationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_locationid_fkey FOREIGN KEY (locationid) REFERENCES public.locations(locationid);


--
-- Name: listingsignups listingsignups_listingid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listingsignups
    ADD CONSTRAINT listingsignups_listingid_fkey FOREIGN KEY (listingid) REFERENCES public.listings(listingid) ON DELETE CASCADE;


--
-- Name: listingsignups listingsignups_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listingsignups
    ADD CONSTRAINT listingsignups_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid) ON DELETE CASCADE;


--
-- Name: messages messages_listingid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_listingid_fkey FOREIGN KEY (listingid) REFERENCES public.listings(listingid) ON DELETE CASCADE;


--
-- Name: messages messages_receiverid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_receiverid_fkey FOREIGN KEY (receiverid) REFERENCES public.users(userid) ON DELETE CASCADE;


--
-- Name: messages messages_senderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_senderid_fkey FOREIGN KEY (senderid) REFERENCES public.users(userid) ON DELETE CASCADE;


--
-- Name: organizations organizations_orgid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_orgid_fkey FOREIGN KEY (orgid) REFERENCES public.users(userid);


--
-- Name: savedlistings savedlistings_listingid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.savedlistings
    ADD CONSTRAINT savedlistings_listingid_fkey FOREIGN KEY (listingid) REFERENCES public.listings(listingid) ON DELETE CASCADE;


--
-- Name: savedlistings savedlistings_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.savedlistings
    ADD CONSTRAINT savedlistings_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

