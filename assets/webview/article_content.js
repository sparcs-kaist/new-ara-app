(function(t) {
    function e(e) {
        for (var a, s, r = e[0], c = e[1], l = e[2], d = 0, p = []; d < r.length; d++)
            s = r[d],
            Object.prototype.hasOwnProperty.call(i, s) && i[s] && p.push(i[s][0]),
            i[s] = 0;
        for (a in c)
            Object.prototype.hasOwnProperty.call(c, a) && (t[a] = c[a]);
        u && u(e);
        while (p.length)
            p.shift()();
        return o.push.apply(o, l || []),
        n()
    }
    function n() {
        for (var t, e = 0; e < o.length; e++) {
            for (var n = o[e], a = !0, r = 1; r < n.length; r++) {
                var c = n[r];
                0 !== i[c] && (a = !1)
            }
            a && (o.splice(e--, 1),
            t = s(s.s = n[0]))
        }
        return t
    }
    var a = {}
      , i = {
        app: 0
    }
      , o = [];
    function s(e) {
        if (a[e])
            return a[e].exports;
        var n = a[e] = {
            i: e,
            l: !1,
            exports: {}
        };
        return t[e].call(n.exports, n, n.exports, s),
        n.l = !0,
        n.exports
    }
    s.m = t,
    s.c = a,
    s.d = function(t, e, n) {
        s.o(t, e) || Object.defineProperty(t, e, {
            enumerable: !0,
            get: n
        })
    }
    ,
    s.r = function(t) {
        "undefined" !== typeof Symbol && Symbol.toStringTag && Object.defineProperty(t, Symbol.toStringTag, {
            value: "Module"
        }),
        Object.defineProperty(t, "__esModule", {
            value: !0
        })
    }
    ,
    s.t = function(t, e) {
        if (1 & e && (t = s(t)),
        8 & e)
            return t;
        if (4 & e && "object" === typeof t && t && t.__esModule)
            return t;
        var n = Object.create(null);
        if (s.r(n),
        Object.defineProperty(n, "default", {
            enumerable: !0,
            value: t
        }),
        2 & e && "string" != typeof t)
            for (var a in t)
                s.d(n, a, function(e) {
                    return t[e]
                }
                .bind(null, a));
        return n
    }
    ,
    s.n = function(t) {
        var e = t && t.__esModule ? function() {
            return t["default"]
        }
        : function() {
            return t
        }
        ;
        return s.d(e, "a", e),
        e
    }
    ,
    s.o = function(t, e) {
        return Object.prototype.hasOwnProperty.call(t, e)
    }
    ,
    s.p = "/";
    var r = window["webpackJsonp"] = window["webpackJsonp"] || []
      , c = r.push.bind(r);
    r.push = e,
    r = r.slice();
    for (var l = 0; l < r.length; l++)
        e(r[l]);
    var u = c;
    o.push([0, "chunk-vendors"]),
    n()
}
)({
    0: function(t, e, n) {
        t.exports = n("cd49")
    },
    "000d": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"today-best":"오늘의 인기글","weekly-best":"이주의 인기글","ara-notice":"뉴아라 공지","document-title":"Ara - 홈"},"en":{"today-best":"Daily Best","weekly-best":"Weekly Best","ara-notice":"Ara Notice","document-title":"Ara - Home"}}'),
            delete t.options._Ctor
        }
    },
    "0349": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"language":"English","title":"이용 약관","agreed":"동의하셨습니다","already-agreed":"이미 동의하셨습니다.","exit-confirm":"약관에 동의하지 않으면 서비스를 이용하실 수 없습니다. 이대로 나가시겠습니까?","agree":"동의","disagree":"동의하지 않음","tos-header":"new Ara (이하 아라) 이용약관은 현재 적용 중입니다.","tos-sections":[{"title":"제 1조. 아라의 목적","contents":"1. 아라는 KAIST 구성원의 원활한 정보공유를 위해 KAIST 학부 동아리 SPARCS (이하 \\"SPARCS\\")에서 제공하는 공용 게시판 서비스 (Bulletin Board System) 입니다.\\n2. 1조 1항에서의 KAIST 구성원이란 교수, 교직원, 그리고 재학생과 졸업생, 입주 업체 등을 나타냅니다."},{"title":"제 2조. 가입 및 탈퇴","contents":"1. 아라는 KAIST 구성원만 이용 가능합니다.\\n2. 아라는 SPARCS SSO를 통해 가입할 수 있습니다.\\n  - SPARCS SSO에서 카이스트 통합인증으로 가입시 별도 승인 없이 바로 서비스 이용이 가능합니다. (교수, 교직원, 재학생, 졸업생 등)\\n  - SPARCS SSO에서 카이스트 통합인증 외 다른 방법으로 가입시 아라 운영진이 승인해야만 서비스 이용이 가능합니다. (입주 업체 등)\\n3. 아라는 회원탈퇴 기능이 없습니다. 다만, 아라 운영진에게 회원 탈퇴를 요청할 수 있습니다.\\n4. 다음의 경우에는 회원자격이 박탈될 수 있습니다.\\n  - 카이스트 구성원이 아닌 것으로 밝혀졌을 경우\\n  - new Ara 이용약관에 명시된 회원의 의무를 지키지 않은 경우\\n  - 아라 이용 중 정보통신망 이용촉진 및 정보보호 등에 관한 법률 및 관계 법령과 본 약관이 금지하거나 공서양속에 반하는 행위를 하는 경우"},{"title":"제 3조. 회원의 의무","contents":"1. 회원은 아라 이용과 관련하여 다음의 행위를 하여서는 안 됩니다.\\n  - SPARCS, 아라 운영진, 또는 특정 개인 및 단체를 사칭하는 행위\\n  - 아라를 이용하여 얻은 정보를 원작자나 아라 운영진의 사전 승낙 없이 복사, 복제, 변경, 번역, 출판, 방송, 기타의 방법으로 사용하거나 이를 타인에게 제공하는 행위\\n  - 다른 회원의 계정을 부정 사용하는 행위\\n  - 타인의 명예를 훼손하거나 모욕하는 행위\\n  - 타인의 지적재산권 등의 권리를 침해하는 행위\\n  - 해킹행위 또는 컴퓨터바이러스의 유포 행위\\n  - 광고성 정보 등 일정한 내용을 지속적으로 전송하는 행위\\n  - 서비스의 안전적인 운영에 지장을 주거나 줄 우려가 있는 일체의 행위\\n  - 범죄행위를 목적으로 하거나 기타 범죄행위와 관련된 행위\\n  - SPARCS의 동의 없이 아라를 영리목적으로 사용하는 행위\\n  - 기타 아라의 커뮤니티 강령에 반하거나 아라 서비스 운영상 부적절하다고 판단하는 행위\\n2. 회원은 아라 이용시 모든 상황에서 다음의 커뮤니티 강령을 유의해야합니다.\\n  - 언제나 스스로의 말에 책임감을 가져주시기 바랍니다.\\n  - KAIST 인권윤리센터의 방침에 따라 증오와 차별 표현은 지양해주시고, 국가인권위원회법이 규정한 평등권 침해의 차별행위가 포함되지 않도록 부탁드립니다.\\n  - 국가인권위원회법이 금지하는 차별행위 19가지\\n  - 글에 욕설/비속어/은어를 자제해주시기 바랍니다.\\n  - 글에 상대방이 불쾌감을 느낄 수 있는 표현, 일체의 성적 대상화를 자제해주시기 바랍니다."},{"title":"제 4조. 게시물에 대한 권리","contents":"1. 회원이 아라 내에 올린 게시물의 저작권은 게시한 회원에게 귀속됩니다.\\n2. 서비스의 게시물 또는 내용물이 위의 약관에 위배될 경우 사전 통지나 동의 없이 삭제될 수 있습니다.\\n3. 제 3조 회원의 의무에 따라, 아라를 이용하여 얻은 정보를 원작자나 아라 운영진의 사전 승낙 없이 복사, 복제, 변경, 번역, 출판, 방송, 기타의 방법으로 사용하거나, 영리목적으로 활용하거나, 이를 타인에게 제공하는 행위는 금지됩니다."},{"title":"제 5조. 책임의 제한","contents":"1. SPARCS는 다음의 사유로 서비스 제공을 중지하는 것에 대해 책임을 지지 않습니다.\\n  - 설비의 보수 등을 위해 부득이한 경우\\n  - KAIST가 전기통신서비스를 중지하는 경우\\n  - 천재지변, 정전 및 전시 상황인 경우\\n  - 기타 본 서비스를 제공할 수 없는 사유가 발생한 경우\\n2. SPARCS는 다음의 사항에 대해 책임을 지지 않습니다.\\n  - 개재된 회원들의 글에 대한 신뢰도, 정확도\\n  - 아라를 매개로 회원 상호 간 및 회원과 제 3자 간에 발생한 분쟁\\n  - 기타 아라 사용 중 발생한 피해 및 분쟁\\n3. 법적 수사 요청이 있는 경우, SPARCS는 수사기관에 회원 개인정보를 제공할 수 있습니다."},{"title":"제 6조. 문의 및 제보","contents":"1. 아라에 대한 건의사항 또는 버그에 대한 사항은 구글폼을 통해 문의 및 제보할 수 있습니다. (<a style=\\"color: #00b8d4;\\" target=\\"_blank\\" href=\\"https://sparcs.page.link/newara-feedback\\">https://sparcs.page.link/newara-feedback</a>)\\n2. 6조 1항의 구글폼이 작동하지 않거나, 기타 사항의 경우 new-ara@sparcs.org 를 통해 문의 및 제보할 수 있습니다."},{"title":"제 7조. 게시, 개정 및 해석","contents":"1. 아라 운영진은 본 약관에 대해 아라 회원가입시 회원의 동의를 받습니다.\\n2. 아라 운영진은 약관의규제에관한법률, 정보통신망이용촉진및정보보호등에관한법률 등 관련법을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.\\n3. 본 약관을 개정하는 경우 적용일자, 개정 내용 및 사유를 명시하여 개정 약관의 적용일자 7일 전부터 적용일자 전일까지 아라의 \'뉴아라 공지\' 게시판을 통해 공지합니다.\\n4. 회원은 개정약관이 공지된 지 7일 내에 개정약관에 대한 거부의 의사표시를 할 수 있습니다. 이 경우 회원은 아라 운영진에게 메일을 발송하여 즉시 사용 중인 모든 지원 서비스를 해지하고 본 서비스에서 회원 탈퇴할 수 있습니다.\\n5. 아라 운영진은 개정약관이 공지된 지 7일 내에 거부의 의사표시를 하지 않은 회원에 대해 개정약관에 대해 동의한 것으로 간주합니다.\\n6. 본 약관의 해석은 아라 운영진이 담당하며, 분쟁이 있을 경우 민법 등 관계 법률과 관례에 따릅니다."}],"tos-footer":"본 약관은 2020-09-26부터 적용됩니다."},"en":{"language":"한국어","title":"Terms of service","agreed":"You\'ve agreed to the Terms of Service","already-agreed":"You\'ve already agreed.","exit-confirm":"If you do not agree to the terms of service, you will not be able to use the service. Would you like to leave?","agree":"Agree","disagree":"Disagree","tos-header":"The terms and conditions of new Ara (\\"Ara\\") are currently in effect.","tos-sections":[{"title":"I. Ara\'s Purpose","contents":"1. Ara is a public bulletin board system provided by KAIST undergraduate club SPARCS (\\"SPARCS\\") for the smooth sharing of information among KAIST members.\\n2. In section I.1, KAIST members refer to professors, faculty, students, graduates, tenant companies, etc."},{"title":"II. Register and Withdraw","contents":"1. Ara is only available to KAIST members.\\n2. Ara can be registered through SPARCS SSO.\\n  - When you sign up with KAIST IAM in SPARCS SSO, you can use the service immediately without any additional approval (professors, faculty, students, graduates, etc.).\\n  - When you sign up with other methods without KAIST IAM in SPARCS SSO, The service can only be used by the Ara management team (such as tenant companies).\\n3. Ara does not have a withdrawal function. However, you can request Ara\'s management team to withdraw membership.\\n4. Membership may be revoked in the following cases:\\n- If found not to be a member of KAIST;\\n- Failure to comply with the obligations of the members specified in the Ara\'s Terms of Service;\\n- Where the Act on Promotion of Information and Communications Network Utilization and Information Protection, the related statute, prohibited acts by the Terms of Service or an act contrary to the public order during the use of Ara;"},{"title":"III. Member\'s duty","contents":"1. The member shall not perform any of the following acts in connection with the use of Ara:\\n  - Impersonating SPARCS, Ara management team, or a specific individual or organization.\\n  - Copying, duplicating, changing, translating, publishing, broadcasting, or providing information obtained using Ara to others without prior consent from the authorship or Ara management team.\\n  - Fraudulently using another member\'s account\\n  - Defaming or insulting others.\\n  - Infringing on the rights of others, such as intellectual property, etc.\\n  - Hacking or distributing computer viruses\\n  - Continuously transmitting certain contents, such as advertising information.\\n  - Any act that is likely to interfere with or hinder the safe operation of the service.\\n  - Any act aimed at or related to a criminal act.\\n  - The act of using Ara for profit without the consent of SPARCS.\\n  - Other acts against Ara\'s Community Code or deemed inappropriate in the operation of Ara services.\\n2. When using Ara, members should pay attention to the following Community Code in all situations.\\n  - Always be responsible for what you say.\\n  - Please refrain from expressing hatred and discrimination in accordance with the policy of KAIST\'s Human Rights Ethics Center, and do not include discriminatory acts against the infringement of equal rights as stipulated by the National Human Rights Commission of Korea Act.\\n  - 19 Discrimination Actions Banned by the National Human Rights Commission of Korea Act\\n  - Please refrain from swearing / slang in your post.\\n  - Please refrain from sexually objectifying, and any expressions that may offend the other people."},{"title":"IV. Right to Post","contents":"1. The copyright of the posting posted within Ara belongs to the member who posted it.\\n2. If the posts or contents of the service violate the terms of service above, they may be deleted without prior notice or consent.\\n3. In accordance with the obligations of the members of III, copying, changing, translating, publishing, broadcasting, or providing information obtained using Ara to others is prohibited without prior consent from the original author or Ara management team."},{"title":"V. Limitation of Liability","contents":"1. SPARCS is not responsible for discontinuing the service due to the following reasons:\\n  - In case it is inevitable for repair of equipment, etc.\\n  - When KAIST stops telecommunication service\\n  - In case of natural disasters, power outages and wartime situations\\n  - Other reasons for not being able to provide this service arise.\\n2. SPARCS is not responsible for the following matters:\\n  - Accuracy, and reliability of the members\' posts.\\n  - Disputes arising between members and and third parties through Ara\'s medium\\n  - Other damages and disputes arising from the use of Ara\\n3. SPARCS may provide member\'s personal information to the investigative agency in the event of a legal investigation request."},{"title":"VI. Inquiries and reports","contents":"1. Suggestions for Ara or bug can be inquired and reported through Google forms. (<a style=\\"color: #00b8d4;\\" target=\\"_blank\\" href=\\"https://sparcs.page.link/newara-feedback\\">https://sparcs.page.link/newara-feedback</a>)\\n2. If the Google Form does not work or if there is anything else to inquire, you can contact and inform us at new-ara@sparcs.org."},{"title":"VII. Publish, revise, and interpret","contents":"1. The Ara management team obtains the consent of the members when signing up for Ara membership in this Agreement.\\n2. The Ara management team may amend this Agreement to the extent that it does not violate the relevant laws, such as the Act on the Regulation of Terms and Conditions and the Act on the Promotion of Information and Communication Network Utilization and Information Protection, etc.\\n3. In the event of amending this Agreement, the date of application, details and reasons for the amendment shall be stated and notified through the \'New Ara Notice\' bulletin board from 7 days before the date of application to the day before the date of application.\\n4. The member may express his/her rejection of the revised terms within 7 days after the announcement of the revised terms of service. In this case, the member may immediately terminate all support services in use by sending an email to Ara management team and withdraw from this service.\\n5. The Ara management team considers the members who have not expressed their rejection within 7 days of the announcement of the revised terms to have agreed to the amended terms of service.\\n6. The interpretation of these terms and conditions is handled by the Ara management team, and if there is a dispute, it is in accordance with relevant laws and practices, such as civil law."}],"tos-footer":"These terms of service apply from 2020-09-26."}}'),
            delete t.options._Ctor
        }
    },
    "038d": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"document-title":"Ara - 알림","title":"알림"},"en":{"document-title":"Ara - Notifications","title":"Notifications"}}'),
            delete t.options._Ctor
        }
    },
    "03fd": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"landing":{"text":"{ara} {accurate}를 {fast}","ara":"ARA,","accurate":"가장 정확한 정보","fast":"가장 신속하게."},"keyword":"키워드"},"en":{"landing":{"text":"{ara} {fast} delivery of {accurate}","ara":"ARA,","accurate":"the most accurate information","fast":"the fastest"},"keyword":"Keywords"}}'),
            delete t.options._Ctor
        }
    },
    "0419": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"language":"English","notification":"알림","write":"게시글 작성하기","all":"전체보기","talk":"자유게시판","my-page":"마이페이지","logout":"로그아웃","group":{"notice":"공지","communication":"소통","money":"거래","clubs":"학생 단체 및 동아리"},"morealarm":"알림 더 보기"},"en":{"language":"한국어","notification":"Notifications","write":"Write Post","all":"All","talk":"Talk","my-page":"My Page","logout":"Logout","group":{"notice":"Notice","communication":"Communication","money":"Money","clubs":"Organizations and Clubs"},"morealarm":"See more Alarms"}}'),
            delete t.options._Ctor
        }
    },
    "0b25": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push("null"),
            delete t.options._Ctor
        }
    },
    "0d2e": function(t, e, n) {
        "use strict";
        n("cb91")
    },
    "0fdb": function(t, e, n) {
        "use strict";
        var a = n("3308")
          , i = n.n(a);
        e["default"] = i.a
    },
    "121f": function(t, e, n) {
        "use strict";
        n("ba5f")
    },
    "157a": function(t, e, n) {
        "use strict";
        n("bcaa")
    },
    1660: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"hidden-user":"가려진 사용자","delete":"삭제","report":"신고","edit":"수정","fold-reply-comment":"답글접기","reply-comment":"답글쓰기","placeholder":"입력...","new-reply-comment":"작성하기","confirm-delete":"정말로 이 댓글을 삭제하시겠습니까?","confirm-report":"정말로 이 댓글을 신고하시겠습니까?","nonvotable-myself":"본인 게시물이나 댓글에는 좋아요를 누를 수 없습니다!","show-hidden":"댓글 보기","ADULT_CONTENT":"성인/음란성 내용의 댓글입니다.","SOCIAL_CONTENT":"정치/사회성 내용의 댓글입니다.","REPORTED_CONTENT":"신고 누적으로 숨김된 댓글입니다.","BLOCKED_USER_CONTENT":"차단한 사용자의 댓글입니다.","DELETED_CONTENT":"삭제된 댓글입니다."},"en":{"hidden-user":"Hidden user","delete":"Delete","report":"Report","edit":"Edit","fold-reply-comment":"Close reply","reply-comment":"Reply","placeholder":"Type here...","new-reply-comment":"Send","confirm-delete":"Are you really want to delete this comment?","confirm-report":"Are you really want to report this comment?","show-hidden":"Show Hidden Comment","nonvotable-myself":"You cannot vote for your post or comment!","ADULT_CONTENT":"This comment has adult/obscene contents.","SOCIAL_CONTENT":"This comment has political/social contents.","REPORTED_CONTENT":"This comment was hidden due to cumulative reporting.","BLOCKED_USER_CONTENT":"This comment was written by blocked user.","DELETED_CONTENT":"This comment has been deleted."}}'),
            delete t.options._Ctor
        }
    },
    1681: function(t, e, n) {
        "use strict";
        n("5dd0")
    },
    1704: function(t, e, n) {},
    "18ac": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"comment":"댓글 내용"},"en":{"comment":"Comment"}}'),
            delete t.options._Ctor
        }
    },
    "1d69": function(t, e, n) {
        t.exports = n.p + "img/LogoSWF.1e62da0e.png"
    },
    "1e49": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"search":"{title}에서 {query} 검색"},"en":{"search":"Search {query} from {title}"}}'),
            delete t.options._Ctor
        }
    },
    "1f91": function(t, e, n) {
        t.exports = n.p + "img/LogoNSA.4c0b9092.png"
    },
    "1fe7": function(t, e, n) {},
    2044: function(t, e, n) {},
    "22f8": function(t, e, n) {
        "use strict";
        var a = n("0419")
          , i = n.n(a);
        e["default"] = i.a
    },
    "23f7": function(t, e, n) {},
    2414: function(t, e, n) {
        "use strict";
        n("3258")
    },
    2521: function(t, e, n) {
        "use strict";
        n("a0ca")
    },
    "254e": function(t, e, n) {
        "use strict";
        n("f424")
    },
    "268f": function(t, e, n) {
        "use strict";
        n("a443")
    },
    "27bf": function(t, e, n) {
        var a = {
            "./en.yaml": "305f",
            "./ko.yaml": "ae2e"
        };
        function i(t) {
            var e = o(t);
            return n(e)
        }
        function o(t) {
            if (!n.o(a, t)) {
                var e = new Error("Cannot find module '" + t + "'");
                throw e.code = "MODULE_NOT_FOUND",
                e
            }
            return a[t]
        }
        i.keys = function() {
            return Object.keys(a)
        }
        ,
        i.resolve = o,
        t.exports = i,
        i.id = "27bf"
    },
    "28c2": function(t, e, n) {
        "use strict";
        n("ebdf")
    },
    "2aba": function(t, e, n) {
        "use strict";
        var a = n("f9dd")
          , i = n.n(a);
        e["default"] = i.a
    },
    "2b81": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"credit":"만든 사람들","license":"라이센스","rules":"이용 약관","contact":"문의","ask":"채널톡 문의하기"},"en":{"credit":"Credit","license":"License","rules":"Terms of Service","contact":"Contact","ask":"Ask ChannelTalk"}}'),
            delete t.options._Ctor
        }
    },
    "2d24": function(t, e, n) {
        "use strict";
        var a = n("a152")
          , i = n.n(a);
        e["default"] = i.a
    },
    "2db6": function(t, e, n) {
        "use strict";
        n("7a0e")
    },
    "2e05": function(t, e, n) {
        "use strict";
        var a = n("2b81")
          , i = n.n(a);
        e["default"] = i.a
    },
    "305f": function(t, e) {
        t.exports = {
            all: "All",
            archive: "Archive",
            notification: "Notifications",
            "archive-failed-fetch": "An error occurred while fetching the archived posts!",
            "board-failed-fetch": "An error occurred while fetching the board!",
            "home-failed-fetch": "An error occurred while fetching the home!",
            "myinfo-failed-fetch": "An error occurred while fetching the settings!",
            "notifications-failed-fetch": "An error occurred while fetching the notifications!",
            "post-failed-fetch": "An error occurred while fetching the post!",
            "user-failed-fetch": "An error occurred while fetching the user!",
            "write-failed-fetch": "An error occurred while fetching the editing post!",
            ADULT_CONTENT: "This post has adult/obscene contents.",
            SOCIAL_CONTENT: "This post has political/social contents.",
            REPORTED_CONTENT: "This post was hidden due to cumulative reporting.",
            BLOCKED_USER_CONTENT: "This post was written by blocked user.",
            ACCESS_DENIED_CONTENT: "You do not have access to this post."
        }
    },
    3104: function(t, e, n) {
        "use strict";
        var a = n("658b")
          , i = n.n(a);
        e["default"] = i.a
    },
    3146: function(t, e, n) {
        "use strict";
        n("f41e")
    },
    3258: function(t, e, n) {},
    3308: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"more":"더보기"},"en":{"more":"More"}}'),
            delete t.options._Ctor
        }
    },
    "34ea": function(t, e, n) {},
    "35d1": function(t, e, n) {
        "use strict";
        n("e1eb")
    },
    3629: function(t, e, n) {},
    "39bd": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"ranking-title":"나의 활동 기록","ranking-subtitle":"{user} 님의 등급은 {ranking}입니다.","ranking-posts":"게시글","ranking-comments":"댓글","ranking-likes":"받은 공감","ranking-posts-count":"{count}개","ranking-comments-count":"{count}개","ranking-likes-count":"{count}회","settings-title":"게시글 보기 설정","settings-subtitle":"조회하실 게시글의 종류를 설정해주세요.","settings-sexual":"성인글 보기","settings-social":"정치글 보기","blocked-title":"내가 차단한 유저 목록","blocked-subtitle":"{user} 님이 차단하신 유저 목록입니다.<br />하루에 최대 10번만 변경 가능합니다.","blocked-empty":"차단한 유저가 없습니다.","empty-email":"이메일 주소가 없습니다.","save":"확인","cancel":"취소","my-info":"내 정보","board-my":"내가 쓴 글","board-recent":"최근 본 글","board-archive":"담아둔 글","settings":"설정","setting-change-failed":"설정 변경 중 문제가 발생했습니다.","unblock-failed":"차단 유저 삭제 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.","success":"저장되었습니다.","document-title":"Ara - 내정보","block-rate-limit":"하루에 최대 10번만 차단/해제 할 수 있습니다."},"en":{"ranking-title":"My Activity","ranking-subtitle":"Your ranking is {ranking}","ranking-posts":"Posts","ranking-comments":"Comments","ranking-likes":"Likes","ranking-posts-count":"{count}","ranking-comments-count":"{count}","ranking-likes-count":"{count}","settings-title":"Post settings","settings-subtitle":"Choose types of posts you want to view.","settings-sexual":"Sexual posts","settings-social":"Political posts","blocked-title":"Blocked users","blocked-subtitle":"Users that you blocked<br />You could change it at most 10 times a day","blocked-empty":"There are no blocked users.","empty-email":"No email address","save":"Confirm","cancel":"Cancel","my-info":"My info","board-my":"My posts","board-recent":"History","board-archive":"Bookmarks","settings":"Settings","setting-change-failed":"Failed while updating settings.","unblock-failed":"Failed while unblocking user. Please try again after a while.","success":"Saved successful.","document-title":"Ara - MyInfo","block-rate-limit":"You could block/unblock at most 10 times a day."}}'),
            delete t.options._Ctor
        }
    },
    "3cc7": function(t, e, n) {
        "use strict";
        var a = n("0b25")
          , i = n.n(a);
        e["default"] = i.a
    },
    "3da6": function(t, e, n) {},
    "3fc3": function(t, e, n) {
        "use strict";
        var a = n("c8a7")
          , i = n.n(a);
        e["default"] = i.a
    },
    4079: function(t, e, n) {
        "use strict";
        var a = n("4d35")
          , i = n.n(a);
        e["default"] = i.a
    },
    4101: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"title":"Ara (아라): 가장 정확한 정보를 가장 신속하게.","subtitle":"Ara 어플리케이션 설치하기 (데스크탑, 안드로이드, iOS)","install":"설치","close":"닫기"},"en":{"title":"Ara: the fastest delivery of the most accurate information","subtitle":"Install Ara application (desktop, Android, iOS)","install":"Install","close":"Close"}}'),
            delete t.options._Ctor
        }
    },
    4213: function(t, e, n) {},
    "44c8": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"nonvotable-myself":"본인 게시물이나 댓글에는 좋아요를 누를 수 없습니다!","impossible-cancel-like":"좋아요가 20개를 넘은 경우 취소할 수 없습니다!"},"en":{"nonvotable-myself":"You cannot vote for your post or comment!","impossible-cancel-like":"If there are more than 20 likes, you cannot cancel it!"}}'),
            delete t.options._Ctor
        }
    },
    4543: function(t, e, n) {
        "use strict";
        n("1fe7")
    },
    4634: function(t, e, n) {
        "use strict";
        n("7b7e")
    },
    4659: function(t, e, n) {},
    "4b2c": function(t, e, n) {},
    "4b62": function(t, e, n) {
        "use strict";
        n("c5c6")
    },
    "4bd9": function(t, e, n) {
        "use strict";
        var a = n("000d")
          , i = n.n(a);
        e["default"] = i.a
    },
    "4d35": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"placeholder":"댓글을 작성하세요.","new-comment":"등록","close-comment":"취소","write-failed":"댓글 작성을 실패했습니다.","no-empty":"내용을 입력해주세요.","author":"글쓴이"},"en":{"placeholder":"Type here...","new-comment":"Write","close-comment":"Cancel","write-failed":"Failed to write comment.","no-empty":"Please fill in the empty input.","author":"Author"}}'),
            delete t.options._Ctor
        }
    },
    "55bf": function(t, e, n) {
        "use strict";
        n("81ce")
    },
    "56a9": function(t, e, n) {},
    5774: function(t, e, n) {
        "use strict";
        n("7dac")
    },
    5857: function(t, e, n) {
        "use strict";
        n("bf61")
    },
    5867: function(t, e, n) {
        "use strict";
        n("d803")
    },
    "58bc": function(t, e, n) {},
    "5c0b": function(t, e, n) {
        "use strict";
        n("9c0c")
    },
    "5dd0": function(t, e, n) {},
    "5dee": function(t, e, n) {
        "use strict";
        n("23f7")
    },
    "61ab": function(t, e, n) {},
    "658b": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"upload":"첨부파일","upload-button":"가져오기","dropzone-normal":"가져오기 버튼을 클릭하거나 복사한 이미지를 본문에서 붙여넣기, 또는 파일을 드래그 앤 드롭해주세요.","dropzone-drop":"여기에 드롭해주세요.","dropzone-unallowed-extensions":"허용되지 않은 확장자입니다."},"en":{"upload":"Upload Attachments","upload-button":"Import","dropzone-normal":"Please click import button, paste copied images, or drag & drop the files.","dropzone-drop":"Please drop here.","dropzone-unallowed-extensions":"This file type is not allowed."}}'),
            delete t.options._Ctor
        }
    },
    "6c86": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"archive":"담아두기","unarchive":"담아두기 취소","block":"차단","unblock":"차단 해제","report":"신고","edit":"수정","delete":"삭제","copy-url":"URL 복사","attachments":"첨부파일 모아보기","more":"{author} 님의 게시글 더 보기","show-hidden":"숨김글 보기","confirm-delete":"정말로 삭제하시겠습니까?","hidden-notice-ADULT_CONTENT":"게시물 보기 설정은 마이페이지에서 수정할 수 있습니다.","hidden-notice-SOCIAL_CONTENT":"게시물 보기 설정은 마이페이지에서 수정할 수 있습니다.","hidden-notice-BLOCKED_USER_CONTENT":"차단 사용자 설정은 마이페이지에서 확인할 수 있습니다."},"en":{"archive":"Bookmark","unarchive":"Delete Bookmark","block":"Block","unblock":"Unblock","report":"Report","edit":"Edit","delete":"Delete","copy-url":"Copy URL","attachments":"Attachments","more":"Read more posts by {author}","show-hidden":"Show hidden posts","confirm-delete":"Are you really want to delete this post?","hidden-notice-ADULT_CONTENT":"You can change the setting in your MyInfo page to show this kinds of post.","hidden-notice-SOCIAL_CONTENT":"You can change the setting in your MyInfo page to show this kinds of post.","hidden-notice-BLOCKED_USER_CONTENT":"You can change blocked users in your MyInfo page."}}'),
            delete t.options._Ctor
        }
    },
    "6fb9": function(t, e, n) {
        "use strict";
        n("61ab")
    },
    "70b9": function(t, e, n) {},
    7408: function(t, e, n) {
        "use strict";
        var a = n("a47c")
          , i = n.n(a);
        e["default"] = i.a
    },
    7435: function(t, e, n) {
        "use strict";
        n("58bc")
    },
    "774a": function(t, e, n) {
        "use strict";
        n("4659")
    },
    "797d": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"readAll":"모두 읽음"},"en":{"readAll":"Read All"}}'),
            delete t.options._Ctor
        }
    },
    "7a0e": function(t, e, n) {},
    "7b11": function(t, e, n) {
        "use strict";
        var a = n("4101")
          , i = n.n(a);
        e["default"] = i.a
    },
    "7b7e": function(t, e, n) {},
    "7be2": function(t, e, n) {},
    "7bff": function(t, e, n) {
        t.exports = n.p + "img/LogoUA.eedadd98.png"
    },
    "7ca9": function(t, e, n) {},
    "7dac": function(t, e, n) {},
    "7ea7": function(t, e, n) {
        "use strict";
        n("c72b")
    },
    "80f5": function(t, e, n) {
        "use strict";
        n("9ffe")
    },
    "81ce": function(t, e, n) {},
    8453: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"archived":"담아둔 게시글에 추가했습니다!","unarchived":"담아둔 게시글에서 제거했습니다!","reported":"해당 게시물을 신고했습니다!","blocked":"해당 유저가 차단되었습니다!","unblocked":"해당 유저가 차단 해제되었습니다!","confirm-report":"게시물 신고 사유를 알려주세요.","confirm-block":"정말로 차단하시겠습니까?","nonvotable-myself":"본인 게시물에는 좋아요를 누를 수 없습니다!","already-reported":"이미 신고한 게시물입니다.","hidden-post":"숨겨진 글","report-unavailable":"신고가 불가능한 글입니다!","block-rate-limit":"하루에 최대 10번만 차단/해제 할 수 있습니다.","copy-success":"URL을 클립보드에 복사했습니다."},"en":{"archived":"Successfully added to your archive!","unarchived":"Successfully removed from your archive!","reported":"Successfully reported the post!","blocked":"The user has been blocked!","unblocked":"The user has been unblocked!","confirm-report":"Let us know your reason for reporting the post.","confirm-block":"Do you really want to block this user?","nonvotable-myself":"You cannot vote for your post!","already-reported":"You\'ve already reported this article.","hidden-post":"Hidden post","report-unavailable":"You cannot report this post!","block-rate-limit":"You can block/unblock at most 10 times a day.","copy-success":"Copied URL to the clipboard."}}'),
            delete t.options._Ctor
        }
    },
    "84d7": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"comments":"댓글","views":"조회수","status":{"polling":"달성전","preparing":"답변 준비중","answered":"답변 완료"}},"en":{"comments":"Reply","views":"View","status":{"polling":"Polling","preparing":"Preparing","answered":"Answered"}}}'),
            delete t.options._Ctor
        }
    },
    "85e4": function(t, e, n) {
        "use strict";
        var a = n("39bd")
          , i = n.n(a);
        e["default"] = i.a
    },
    8785: function(t, e, n) {
        "use strict";
        n("d607")
    },
    "8b99": function(t, e, n) {
        "use strict";
        var a = n("932e")
          , i = n.n(a);
        e["default"] = i.a
    },
    "8cb5": function(t, e, n) {
        "use strict";
        n("7ca9")
    },
    9033: function(t, e, n) {
        "use strict";
        var a = n("797d")
          , i = n.n(a);
        e["default"] = i.a
    },
    "92f2": function(t, e, n) {
        "use strict";
        n("34ea")
    },
    "932e": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"small":"작게","mid":"중간","large":"크게"},"en":{"small":"small","mid":"mid","large":"large"}}'),
            delete t.options._Ctor
        }
    },
    9387: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"write":"게시물 작성하기","input-title":"제목을 입력하세요","input-board":"게시판을 선택하세요","input-board-warning":"게시판을 선택해주세요","input-category":"말머리를 선택하세요","input-category-warning":"말머리를 선택해주세요","write-publish":"게시글 등록하기","write-edit":"게시글 수정하기","no-category":"말머리 없음","uploading":"현재 업로딩 중입니다.","is-sexual":"성인글","is-social":"정치글","is-anonymous":"익명"},"en":{"write":"Write a post","input-title":"Type title here","input-board":"Select Board","input-board-warning":"You should select a board","input-category":"Select Category","input-category-warning":"You should select a category","no-category":"No Category","write-publish":"Publish Post","write-edit":"Edit a post","uploading":"It is currently uploading post. Please wait for a second.","is-sexual":"Adult Post","is-social":"Politics Post","is-anonymous":"Anonymous"}}'),
            delete t.options._Ctor
        }
    },
    "98ca": function(t, e, n) {
        "use strict";
        var a = n("9ba6")
          , i = n.n(a);
        e["default"] = i.a
    },
    "9a8f": function(t, e, n) {
        "use strict";
        var a = n("6c86")
          , i = n.n(a);
        e["default"] = i.a
    },
    "9b78": function(t, e, n) {
        "use strict";
        n("cd8f")
    },
    "9ba6": function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"portal-notice":"포탈공지","all-posts":"전체 게시물","clubs-union":"동아리연합회","dormitory-council":"생활관 자치회","welfare-committee":"학생복지위원회","undergraduate-association":"총학생회","graduate-association":"대학원 총학생회","freshman-council":"새내기학생회","kcoop":"협동조합"},"en":{"portal-notice":"Portal Notice","all-posts":"All Posts","clubs-union":"Clubs Union","dormitory-council":"Dormitory Council","welfare-committee":"Welfare Committee","undergraduate-association":"Undergraduate Association","graduate-association":"Graduate Association","freshman-council":"Freshman Council","kcoop":"KCOOP"}}'),
            delete t.options._Ctor
        }
    },
    "9c0c": function(t, e, n) {},
    "9e20": function(t, e, n) {
        t.exports = n.p + "img/LogoKCOOP.593a2786.png"
    },
    "9eb0": function(t, e, n) {
        "use strict";
        var a = n("44c8")
          , i = n.n(a);
        e["default"] = i.a
    },
    "9f67": function(t, e, n) {},
    "9ffe": function(t, e, n) {},
    a0ca: function(t, e, n) {},
    a0d8: function(t, e, n) {},
    a152: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"recent":"최근 본 글","archive":"담아둔 글"},"en":{"recent":"Recent Articles","archive":"Bookmarks"}}'),
            delete t.options._Ctor
        }
    },
    a2de: function(t, e, n) {
        "use strict";
        n("4b2c")
    },
    a443: function(t, e, n) {},
    a46c: function(t, e, n) {
        "use strict";
        n("e375")
    },
    a47c: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"link-attach":"링크 추가하기","link-url":"링크 URL","link-title":"링크 텍스트","link-add":"링크 추가","bookmark-add":"북마크 추가","wrong-url":"잘못된 URL입니다!","wrong-url-desc":"URL은 http:// 또는 https:// 로 시작해야합니다."},"en":{"link-attach":"Add Link","link-url":"Link URL","link-title":"Link Text","link-add":"Add Link","bookmark-add":"Add Bookmark","wrong-url":"Wrong URL!","wrong-url-desc":"URL should start with http:// or https://"}}'),
            delete t.options._Ctor
        }
    },
    a8cd: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"document-title":"Ara - 삭제된 글","go-home":"홈으로","deleted-post":"삭제된 글입니다"},"en":{"document-title":"Ara - Deleted Post","go-home":"Go Home","deleted-post":"Deleted Post"}}'),
            delete t.options._Ctor
        }
    },
    a8dd: function(t, e, n) {
        "use strict";
        var a = n("9387")
          , i = n.n(a);
        e["default"] = i.a
    },
    a9df: function(t, e, n) {
        t.exports = n.p + "img/LogoGSA.1a05cd8c.png"
    },
    aa3d: function(t, e, n) {
        "use strict";
        n("b628")
    },
    aa47: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"no-empty":"빈 칸을 채워주세요.","attachment-failed":"첨부파일 업로드에 실패했습니다. 용량을 다시 한 번 확인해주세요.","create-failed":"글 작성에 실패했습니다. 다시 한 번 시도해주세요.","update-failed":"글 수정에 실패했습니다. 다시 한 번 시도해주세요.","before-unload":"아직 게시글을 올리지 않았습니다!\\n올리지 않고 나가시겠습니까?","before-realname-write":"이 게시판에 게시글을 작성하면 본인의 이름이 실명으로 올라가고, 본인의 닉네임과 개인 프로필은 공개되지 않습니다.\\n정말로 글을 작성하시겠습니까?","document-title":{"write":"Ara - 글쓰기","revise":"Ara - 수정하기"}},"en":{"no-empty":"Please fill in the empty input.","attachment-failed":"Failed to upload attachments. Please double check the size of files.","create-failed":"Failed to write the post. Please try again after a while.","update-failed":"Failed to update the post. Please try again after a while.","before-unload":"This post is not posted yet.\\nAre you sure to exit?","before-realname-write":"When you write a post in this board, your name will be posted as your real name, and your nickname and personal profile will not be revealed.\\nAre you sure to write the post?","document-title":{"write":"Ara - Write","revise":"Ara - Revise"}}}'),
            delete t.options._Ctor
        }
    },
    aa71: function(t, e, n) {
        "use strict";
        n("a0d8")
    },
    aba5: function(t, e, n) {
        t.exports = n.p + "img/LogoKAIST.d8e38fcf.png"
    },
    abbd: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"document-title":"Ara - 페이지 없음","page-not-found":"페이지를 찾을 수 없습니다.","go-home":"홈으로"},"en":{"document-title":"Ara - Not Found","page-not-found":"Page Not Found","go-home":"Go Home"}}'),
            delete t.options._Ctor
        }
    },
    ac24: function(t, e, n) {
        "use strict";
        var a = n("1660")
          , i = n.n(a);
        e["default"] = i.a
    },
    ae2e: function(t, e) {
        t.exports = {
            all: "전체보기",
            archive: "담아두기",
            notification: "알림",
            "archive-failed-fetch": "담아둔 글을 가져오는 동안 오류가 발생했습니다!",
            "board-failed-fetch": "게시판을 가져오는 중 오류가 발생했습니다!",
            "home-failed-fetch": "홈 화면을 가져오는 중 오류가 발생했습니다!",
            "myinfo-failed-fetch": "설정을 가져오는 중 오류가 발생했습니다!",
            "notifications-failed-fetch": "알림을 가져오는 중 오류가 발생했습니다!",
            "post-failed-fetch": "글을 가져오는 동안 오류가 발생했습니다!",
            "user-failed-fetch": "사용자를 가져오는 동안 오류가 발생했습니다!",
            "write-failed-fetch": "수정할 글을 가져오는 동안 오류가 발생했습니다!",
            ADULT_CONTENT: "성인/음란성 내용의 게시물입니다.",
            SOCIAL_CONTENT: "정치/사회성 내용의 게시물입니다.",
            REPORTED_CONTENT: "신고 누적으로 숨김된 게시물입니다.",
            BLOCKED_USER_CONTENT: "차단한 사용자의 게시물입니다.",
            ACCESS_DENIED_CONTENT: "접근 권한이 없는 게시물입니다."
        }
    },
    af80: function(t, e, n) {
        "use strict";
        n("cc50")
    },
    afeb: function(t, e, n) {
        "use strict";
        var a = n("0349")
          , i = n.n(a);
        e["default"] = i.a
    },
    b437: function(t, e, n) {
        t.exports = n.p + "img/LogoGSDC.21bfa0fe.png"
    },
    b460: function(t, e) {
        t.exports = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE8AAABQCAYAAABYtCjIAAAACXBIWXMAAAsSAAALEgHS3X78AAAOm0lEQVR4nL2da4xdVRXH17qiRILORAPyKlOM8RmdIX7SEqaY0iaaOCWihBaYgRhQFJnOYCTYdiZRiRjn9vZFaQrTO22tbWzwIoYoEblVOv3YmfDRRGa+SCWKM4kxxuDdZp/n2nut/Th3bj3JdM4+r33O767Hf6997hSVUkCXF7800UCEIQQABKX/gWQ9/03XHdvA2Kby9ebnzjSatK/BTT8cUoANlRyYHal/I5B1tNahWE+unq+n57X//Py3psFa3px4qIE1GEJUkB0K4npN3k6W8St2zS7kzcvsjhTAECgYTp4YEFClABPGWB6UrDu25R0a5wC0eV/YD4jDJbj0MjK47CQGLu0j/Y3DN915qPHGmW+uWM+0BAoeLW8aQFxX8nYCsJ9etybAS39U+SCK7MzXi/1KOIccp59KAbkfumRwSnDEinKbxvxUYmUUXGnbeRdb2TMpbCX3lPwgiOvg2J6tSwuHJ8LAYhsFCAy0BJ8AZB8UsRwofKWEKbkv5G5dAi0sMz2Owbt+zzNLSuFiEKAEjf5YC4NHLcwFkFoYO0c6N3dFZnlgxToKztwOBCjQ7SToZu2RgbsO99tdKQVNEVT+ITqgFduiLI9YGLMsj4sa5ziOEy0PkLgvsUIDXGaFxGVphrLbIFifUtASrauTQ3JA87hv0G1tUwm5aHGO4tdkfRVu6rHC7DgbnLLAWe1xu691e7XrwgsSiCA0KNf98IJJACNcVEgc0pLHLqckKa2tBAcWKLE9eOP2Z9dzw0gTRwGqUy3+hS0vAqAqU6AjPsa7rZlxA5KEWiuWsdHRZq4LClqFdYFpUU5o1jFeeJK7yS5qZmB2jgCQLcTavJKEbCeSxARugEvaY3Z3N+4/tKIUpq7bhdVVclsKMyRhJEA2fN5XWJKk3DyxLgcLZWLJ9g/eMDoruC60urW67tyW7IyVMOwciR6NaQ5JoohLQjDW2bGRJ46BA4eaqgOrQUsDweqqZlunHKGwI8/hH5Q1Pq0uSeR2GRt53EtvR5YtNii2HoAXAzC/SHmxCAkjdSRIEjOzBiWJM/Nmg+qB6x6YG+LP5x6uGWHKkC+RMY+uOGE4JIwPPutLkCTK65YRbsvbLHHcdPDpllK4KlvaWqSKQ/Aqab+UgT0SRlxckgREEEJbzLS0LbouJCMOAVqFAkG0SKYAQbmPc0kY8f6NzGpJErQkCbhABV164JoHT0jDtUaMpVWUKsgBClDJTURnYKkvURi7YhmVJFDJpRm8Dx96ekEpWK5SlooUycgePCRHwLHf67YBSQJBl41uy1nXVSxYq9sWJeAIgJJlKSEDs74CkkQZEAWJkn8CBngRbN/VD5+UiqTNbq3ODQ/IBa2dXjnCXNQsIvClugQR21D2l49abOuVNN9HDh9cUAqXg9Co5vPCixXJYrKQzuHKvOhrbRLE3TbL8vn+0aseOSUVSRuFSvBAkwwgItsKCYTIERG6IwOLAFm5KVqCRLTtYoJcJKVyBWxoVWIepVheJ5yBjXMcGZh1QR+UgoTuRhURbQbvo0cO6iLpYmyBwAtPclFQAkCH24rwQ9lWenAqSbyF0EouPfLB8V845jfisq4fnktmEAkTm4GphBEXK5PaD15kzlrPJIuYOLxTkwDxbismAUvCBBOHEB9FkRyQJIWEyc0UOFhwxD6w2mQ/K1N97NkDS0WRdC0jDMndnJlVOsdnvfbSxeA/B2lUYgQdyCEXH9LgBx57Xi6S9qIYKmbRQAY246PbAmXLq+qGViWm6NqfiQnE6KlJmnltCwi6rbE9QsI44XN2a5cg1cry1JJZmeoTswdW6NRkYQhEwoQtzztiMJNAFQkjLWYmXZMEiS3L5/sH+x9viVOTRiyvGvNisigVybESxm15LknSk8xaXp/vZ4njk0f3a8my2rVUKT+FyCSQZeASZoT15n1Ig/2egvPGRsf8hv+NKi88yd181lRuM4dgsdmWxa9iVJ8fY0oSW4J4JEkoNg68//svCvMbQtZdi9saIEMuKsEPua1v5FCMNBwC2qH7pLbdl5Q4PtXc30pdt1evWwhyI1bC2PCNvnxulrZ3AMKqmUmh67I8L7LK8xu+IqkXXv4iYsjCbOIlZI+EsZfwgzcVYsuZibsvy+f9DFw59ZI0XGuErE6ER3VarIsa50gZ2OG2gQd94c0j964AQmvN9T1/m8H79LF9C5DMb5QaD6JjHnATrSphQJAwfstjD9rSh1w8fI+2vNVoSQKx4Ir+Ha6LLQpNegaPSEbxwYuBflR8LCWMeIOOoJ+1W+S4VqVRSPEZRsXGvit+8BtpuCa+huuH5wGoygsXB8fER2e2pZLEqJjA3MXD96yQXU1XxSWqUBqOjQzeZ07sK6cmoQTohScC9LhtOD7KJp+zE90OsEUPe+vg3W2FsEyP90kSW2wz8c3lz+h7n3xZnt+oJFUMpWsBiJAwHH55PutLdrvVi4e3t9jBiK1K1mZKEjfksgO5SApduy3xt0gJI8IvLIoBkR6cg0vPb5a307OyPG0zeEMn97Lvb4ThOSyMmk9VCSOLZPHBRXh/2/e1BYW4DL0vy+ftkcufesX7/Q37GSrO25YJxIAdV0RgNwaIS9aDLP/10DYRXnZ804qNMaOUKm3nS+AQOzzzJwFZwpgiWYS60e7rzSP3LgHCInlQN7jUUpsMBAUJXWRis83KVDf/fG/2/Q3UGdj48qEEb0HSdiEJY5wjW+/g8dsnJetrEAnSZPvJ8nb9ziVAXPSCoJKkemwcfPdM2zG/we9HctuVji1HzP2VJIwFn7nFxWe2a2BndTx76+DdC/Z+dn+Z9fkkiSG2iWVmPEMu7ZqaXA7DA7UQU2pS4MjAQtwjp7EvEqeX0bGGV3bFpZAsbklCxDaHDLLYJseyMtVnTzf09zfYvbNvej+1YXKoBnABAaFm3wP9XayXX+b1H1f83nHf72YaUaAcS//jrbbKv+Tcbaatefff9M6jty6F7oNZ3vfOzeiYt6q0DdqWJFoY/xJcQMJMH9s0yeJKlUXp2Nj7sjzdH+UF4vCsA9DWF+4oJUOLkDDgduU+/T2IY5uE5BG7JK7bjSTxluXpGFh+CTwGnlIpvPRhlRHrGJhAEYGKZAJwUAG0uwW4+uSXVwDwhQoSpGIbB2oHzrH5jTh4AK1O9rCdDKArA8dKGEE/aoALxzZNMv0Xs+T1PsNiejXTlrZZ4oiC98T8zJICWLRjnQ1QjHUuCWNrwXR9QAG8emzTZOv47RXjoBbUiKs0MxmSBNbs0kHXZdk2X370+YlxBNyTZ9xa0l9sBk6uHHUc3aZHGwjQQoQ2glrZ9nJ94dSWifUIsP6u39bZnxa5cuolrflGndYUMQaWJomS9eSB1R3qoQ3OUY970hugmWRc6r4xGTi6zse3gYJBAJhSCl5VgBdObp7Qn+0b2jpPb5ngMSiZ3/C4pZFJZZB2qarcrjQdr/U54e2cr68ogLkOARiVgR0ShoH0QC0ONudBWAz65/QXs/mNXpblCzcTRxtR8LL7n06tzg+Qgbk08yDyRE0a+3pWlidWp9f78Og5J0AvvF3zdZ045kpo9MFKCVO1iGCcEz8PMnBqywTPzHmZKn6ulreBgKup0vLSuNcdPEiBjdMRR9cSZk3xsXBf5rr/2rmlDQjLFSSI2C7A0XZqgaN4/DVRjwbhTZ2v65f+pp0JI7YU35t5EIcV0LcKKowq8oRRy0DReGeCFPsNwtPL7vN1PYu0mAM0rI+0PVk0I1LGmSrzIMU5gH0nN0/wklENrTKVnUk9VZSaEeNMcCXI7uFlN781eXsot0DDemKLCKH4GM7ASpjl+vfjmxYU4DJElOUdkoTGOO66CCN4+o/MdRm8G7cd6V+3/VkWmKfOJ8ljvLQ6ZYw61lJE8IEW4uPoyc1iRbpZrSwPprW5QHpkC7c8PSxBbK27d5bd4NT5elMB7C2yr22BBKA/CXQ9D5Jv466bvVUQW5aXYXlBsjIVryQn8KAvuRlhmTpf19ZXyBcpA8clgfA8iBs+h/ef735Bz8QtxhQDWEKwrUzeN4jP/8EYfxvw1t3zXL/276yzkevHmmJRcOp8fawEaMa7DlyyIgI9buSEOJkEzShJYmdWtGFZ+8ptxodWszrfanW257oH5sSSkQaolB6+CRmXubMVt6CUMFVfplTluYLrSi9CCpKkJkgSESRLHobOrFmdjwmdt679+jGxMLg7A6gsgKImdEiYcHzk1pudwwTzOzuG9TzwWXliR5AkLm1XEyww3TeIvz5buG4B74b7ZtcDwrAwxOkDxPY1D54QVfbu1IV3SBZnZGCvhKk8D6J/ho8LcyH5/AaTJHzY5QfJJEuxrwhlpeUZLssCbR8gtD/0jZ+5ADY6Cm5TAMu9lDAggvYnjnJ+wydJbMsKimRxtEHcNndZU50TkIPaAq9++KTLhfW8x1AhZRxFBPBaWKV5EJDKVP995JZ0fgN8kkRxi3OJZA5yAF9uDxXwbhg9uj6BQ8zQ8VciUoDfPiUC3DVfX9k5Xx/vgNJWePb/MQ8yJ7outAKyg1ufuM8BMpvfqEGRKAR9RJU6FPu1Bmxf9Z3TzgmSnfP19hPzMxsVwP3alSmASyBh+H2k7zCvhuOYkvf5QNZK103mMK6/v6kF5kCVSkQ2475XIUz/fc9XV9gDkOXHGyY3IsBYDWD0EsyDLI+9MsOsDw+fa+pyklOSsMwqiGSXRab778Drxo4OKcQLMcrc0V5UNRx7e+YrwZd0ntow2V8D2FpD3IoAIy5o5boqQfoB3jz2yozRPx45p0dKv/Q8vAmrOuQ5vPb+ZgMQHu1+vjMVnwpxLyBO/+Mnd3itkC71Wx7TFrkx+18Q+hFgmANKAb6++if4+PsG4PJ3vWcZAZYQYQEh+Wk/8PsZ8b0SnD23Aqj6nJm1Ckh+7upl2ZCm1TU4ITbGLhOv/VRPJ7Ipxf23Pqb/ZwQ9VEyu++Jfzt7WUZ0zBy/86vVKHSBsBMyuEwvOJWnseIkK/gfAM4ooHnNXHAAAAABJRU5ErkJggg=="
    },
    b54b: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"article-title":"회원님의 게시물에 새로운 댓글이 작성되었습니다.","comment-title":"회원님의 댓글에 새로운 댓글이 작성되었습니다.","article":"게시글","comment":"댓글 내용"},"en":{"article-title":"New comment to your post.","comment-title":"New subcomment to your comment.","article":"Article","comment":"Comment"}}'),
            delete t.options._Ctor
        }
    },
    b628: function(t, e, n) {},
    b7f6: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"title":"KAIST 공식 커뮤니티 ARA가 리뉴얼되었습니다.","from-oct":"10월 31일부로, 리뉴얼된 아라와 함께할 수 있습니다.","notice":"KAIST 학내 모든 정보에 대하여, ","highlight":"가장 정확한 정보를 가장 신속하게","let-access":" 접근할 수 있도록 합니다.","sections":{"please":{"title":"부탁사항","contents":[{"text":"기존 ARA 회원분들도 New-ARA에서 새로 가입을 진행해주셔야 합니다."},{"text":"New-ARA에 대한 각종 피드백은 {link}로 보내주세요.","link-text":"피드백 링크","link":"https://forms.gle/Gb3jJbdpjFRsThAY6"},{"text":"교내 식당, 카페 등 입주업체 분들은 {link}에서 회원등록을 부탁드릴게요.","link-text":"입주업체 등록 링크","link":"https://bit.ly/newara-comp-signup"},{"text":"교내 학생단체 공용계정을 만들고 싶은 분들은 {link}에서 회원등록을 부탁드릴게요.","link-text":"학생단체 등록 링크","link":"https://bit.ly/newara-org-signup"}]},"aware":{"title":"유의사항","contents":[{"text":"베타기간 동안에는 기존 ARA와 new ARA가 함께 운영되며, 새로운 글은 new ARA에만 남길 수 있습니다."},{"text":"베타기간이 끝나면, 기존 ARA 사이트는 내릴 예정입니다."}]}},"more-info":"보다 자세한 내용은 아래 New ARA 이용가이드에서 확인하실 수 있습니다.","start-with":"지금 새로운 ARA와 함께하세요.","new-ara":"New ARA","new-ara-guide-name":"이용 가이드 바로가기","new-ara-guide-exp":"변화된 아라에 대한 가이드를 제공합니다.","new-ara-link":"바로가기","old-ara-link":"기존 ARA 바로가기"},"en":{"title":"The official KAIST community, ARA, has been renewed.","from-oct":"From Oct 31th, you can be with the renewed ARA,","notice":"ARA is designed to provide","highlight":"the fastest delivery of the most accurate information.","let-access":" ","sections":{"please":{"title":"Requests","contents":[{"text":"The users of old ARA also have to sign up for New-ARA."},{"text":"Please give us feedbacks for New-ARA {link}.","link-text":"here (Feedback Link)","link":"https://forms.gle/Gb3jJbdpjFRsThAY6"},{"text":"On-campus companies like resaurants or caffes should sign up {link}.","link-text":"here (On-campus Companies Signup)","link":"https://bit.ly/newara-comp-signup"},{"text":"Student Organizations who want to make a shared account should sign up {link}.","link-text":"here (Student Organizations Signup)","link":"https://bit.ly/newara-org-signup"}]},"aware":{"title":"Note","contents":[{"text":"During the beta period, both old ARA and new ARA will be supported, however, new posts can only be uploaded on new ARA."},{"text":"After the beta test, we will shut down old ARA."}]}},"more-info":"For more information, please check in below New ARA Guide.","start-with":"Now, you are more than welcomed to new ARA!","new-ara":"New ARA","new-ara-guide-name":"guide","new-ara-guide-exp":"We introduce the changed ARA.","new-ara-link":"Link","old-ara-link":"Go to Old ARA."}}'),
            delete t.options._Ctor
        }
    },
    ba1a: function(t, e, n) {
        "use strict";
        var a = n("abbd")
          , i = n.n(a);
        e["default"] = i.a
    },
    ba5f: function(t, e, n) {},
    bbe4: function(t, e, n) {
        "use strict";
        var a = n("8453")
          , i = n.n(a);
        e["default"] = i.a
    },
    bc93: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"no-filter":"없음","filter":"필터","exclude_portal":"포탈 공지글 제외하기","positive-order":"추천순","recent-order":"최신순","all-post":"전체 보기","not-answered":"답변 미완","answered":"답변 완료"},"en":{"no-filter":"No Filter","filter":"Filter","exclude_portal":"Exclude portal notices","positive-order":"Most Likes","recent-order":"Recent","all-post":"All","not-answered":"Not answered","answered":"Answered"}}'),
            delete t.options._Ctor
        }
    },
    bcaa: function(t, e, n) {},
    bdb8: function(t, e, n) {
        "use strict";
        n("9f67")
    },
    bf52: function(t, e, n) {
        "use strict";
        var a = n("18ac")
          , i = n.n(a);
        e["default"] = i.a
    },
    bf61: function(t, e, n) {},
    bf7b: function(t, e, n) {
        "use strict";
        var a = n("1e49")
          , i = n.n(a);
        e["default"] = i.a
    },
    c1a1: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"error":"오류","confirm":"확인","info":"정보","warning":"경고","okay":"확인","cancel":"취소","report":"신고하기","hate_speech":"혐오 발언","unauthorized_sales_articles":"허가되지 않은 판매글","spam":"스팸","fake_information":"거짓 정보","defamation":"명예훼손","other":"기타","need-reason-for-report":"신고 사유를 1개 이상 선택해주세요"},"en":{"error":"Error","confirm":"Confirm","info":"Information","warning":"Warning","okay":"OK","cancel":"Cancel","report":"Report","hate_speech":"Hate Speech","unauthorized_sales_articles":"Unauthorized Sales","spam":"Spam","fake_information":"Fake Information","defamation":"Defamation","other":"Other","need-reason-for-report":"Please select reason for report at least one"}}'),
            delete t.options._Ctor
        }
    },
    c311: function(t, e, n) {
        "use strict";
        var a = n("b54b")
          , i = n.n(a);
        e["default"] = i.a
    },
    c58b: function(t, e, n) {},
    c5c6: function(t, e, n) {},
    c72b: function(t, e, n) {},
    c751: function(t, e, n) {
        "use strict";
        var a = n("03fd")
          , i = n.n(a);
        e["default"] = i.a
    },
    c8a7: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"lang":"English","main":"가장 정확한 정보를<br />가장 신속하게.","login-title":"뉴아라 서비스를 이용하시려면 로그인해주세요.","login-subtitle":"교직원과 졸업생은 SPARCS SSO에 접속한 뒤\\n&lt;카이스트 통합인증으로 로그인/가입&gt;을 선택해주세요.\\n","login":"SPARCS SSO로 로그인","signup-title":"학생단체/입주업체 공용 계정을\\n만들고 싶으신가요?\\n","signup-subtitle":"공용 이메일로 회원가입을 진행한 후,\\n아래 버튼을 클릭하여 신청서를 보내주세요.\\n","signup":"공용 이메일로 회원가입","apply-organization":"학생단체 계정 신청하기","apply-amenity":"입주업체 계정 신청하기"},"en":{"lang":"한국어","main":"the fastest delivery of<br />the most accurate information","login-title":"Please login to use NewAra services","login-subtitle":"For faculties and graduates, please connet to SPARCS SSO\\nand select &lt;Log in/Sign up with KAIST authentication&gt;\\n","login":"Log in with SPARCS SSO","signup-title":"Do you want to make Students Organizations/Amenities account?","signup-subtitle":"Sign up with email, and please click the buttons below\\nto send application forms.\\n","signup":"Sign up with email","apply-organization":"Apply for Organization account","apply-amenity":"Apply for Amenities account"}}'),
            delete t.options._Ctor
        }
    },
    c8f3: function(t, e, n) {
        "use strict";
        n("2044")
    },
    cb91: function(t, e, n) {},
    cc50: function(t, e, n) {},
    cd49: function(t, e, n) {
        "use strict";
        n.r(e);
        n("e260"),
        n("e6cf"),
        n("cca6"),
        n("a79d");
        var a = n("2b0e")
          , i = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                attrs: {
                    id: "root-container"
                }
            }, [n("div", {
                attrs: {
                    id: "app"
                }
            }, [n("router-view"), n("vue-progress-bar")], 1), n("TheFooter")], 1)
        }
          , o = []
          , s = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("footer", {
                staticClass: "the-footer",
                class: {
                    "login-footer": "/login" === this.$route.path
                }
            }, [n("div", {
                staticClass: "footer-menu"
            }, [n("div", {
                staticClass: "footer-item logo-item"
            }, [t._m(0), n("div", {
                staticClass: "footer-contact-mobile is-hidden-tablet"
            }, [t._v(" " + t._s(t.$t("contact")) + ": "), n("a", {
                attrs: {
                    href: "mailto:new-ara@sparcs.org"
                }
            }, [t._v(" new-ara@sparcs.org ")])])]), n("div", {
                staticClass: "footer-items"
            }, [n("div", {
                staticClass: "footer-item"
            }, [n("router-link", {
                attrs: {
                    to: "/makers"
                }
            }, [t._v(" " + t._s(t.$t("credit")) + " ")])], 1), n("div", {
                staticClass: "footer-item"
            }, [n("a", {
                attrs: {
                    href: "https://sparcs.org"
                }
            }, [t._v(" " + t._s(t.$t("license")) + " ")])]), n("div", {
                staticClass: "footer-item"
            }, [n("a", {
                on: {
                    click: function(e) {
                        return t.$refs.terms.openTermsPopup()
                    }
                }
            }, [t._v(" " + t._s(t.$t("rules")) + " ")])]), n("div", {
                staticClass: "footer-item"
            }, [n("a", {
                on: {
                    click: function(e) {
                        return t.openChannelService()
                    }
                }
            }, [t._v(" " + t._s(t.$t("ask")) + " ")])])]), n("div", {
                staticClass: "footer-contact is-hidden-mobile"
            }, [t._v(" " + t._s(t.$t("contact")) + ": "), n("a", {
                attrs: {
                    href: "mailto:new-ara@sparcs.org"
                }
            }, [t._v(" new-ara@sparcs.org ")])])]), n("TermsPopup", {
                ref: "terms",
                attrs: {
                    "agree-tos-at": t.agreeTosAt,
                    show: !1
                }
            })], 1)
        }
          , r = [function() {
            var t = this
              , e = t.$createElement
              , a = t._self._c || e;
            return a("a", {
                attrs: {
                    id: "sparcs-logo",
                    href: "https://sparcs.org"
                }
            }, [a("img", {
                attrs: {
                    src: n("faeb"),
                    alt: "SPARCS"
                }
            })])
        }
        ]
          , c = function() {
            var t = this
              , e = t.$createElement
              , a = t._self._c || e;
            return a("div", {
                staticClass: "modal",
                class: {
                    "is-active": t.termsPopup
                }
            }, [a("div", {
                staticClass: "modal-background"
            }), a("div", {
                staticClass: "modal-content"
            }, [t.agreeTosAt ? a("a", {
                staticClass: "close delete is-medium",
                attrs: {
                    role: "button"
                },
                on: {
                    click: t.exitTermsPopup
                }
            }) : t._e(), a("div", {
                staticClass: "popup"
            }, [a("div", {
                staticClass: "title"
            }, [a("img", {
                staticClass: "Services-Ara",
                attrs: {
                    src: n("fbee")
                }
            }), a("h1", [t._v(t._s(t.$t("title")))]), a("a", {
                staticClass: "toggle-language",
                attrs: {
                    id: "toggle-language"
                },
                on: {
                    click: t.changeLocale
                }
            }, [t._m(0), a("span", [t._v(t._s(t.$t("language")))])])]), a("div", {
                staticClass: "container scrollbar"
            }, [a("div", {
                staticClass: "tos-section"
            }, [t._v(" " + t._s(t.$t("tos-header")) + " ")]), t._l(t.sections, (function(e, n) {
                return a("div", {
                    key: n,
                    staticClass: "tos-section"
                }, [a("h2", {
                    staticClass: "tos-title"
                }, [t._v(" " + t._s(e.title) + " ")]), a("p", {
                    staticClass: "tos-content",
                    domProps: {
                        innerHTML: t._s(e.contents)
                    }
                })])
            }
            )), a("div", {
                staticClass: "tos-section"
            }, [t._v(" " + t._s(t.$t("tos-footer")) + " ")])], 2), a("div", {
                staticClass: "button-container"
            }, [t.agreeTosAt ? t._e() : a("button", {
                staticClass: "button",
                on: {
                    click: t.askAgain
                }
            }, [t._v(" " + t._s(t.$t("disagree")) + " ")]), t.agreeTosAt ? t._e() : a("button", {
                staticClass: "button right-button",
                on: {
                    click: t.agree
                }
            }, [t._v(" " + t._s(t.$t("agree")) + " ")]), t.agreeTosAt ? a("p", [t._v(" " + t._s(t.$t("already-agreed")) + " ")]) : t._e()])])])])
        }
          , l = [function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("span", {
                staticClass: "icon"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("language")])])
        }
        ]
          , u = n("1da1")
          , d = n("a34a")
          , p = n.n(d)
          , m = (n("d3b7"),
        n("159b"),
        n("ddb0"),
        n("ac1f"),
        n("466d"),
        n("a925"));
        function f() {
            var t = n("27bf")
              , e = {};
            return t.keys().forEach((function(n) {
                var a = n.match(/([a-z0-9]+)\./i);
                if (a && a.length > 1) {
                    var i = a[1];
                    e[i] = t(n)
                }
            }
            )),
            e
        }
        a["a"].use(m["a"]);
        var h = new m["a"]({
            locale: "ko",
            fallbackLocale: "ko",
            messages: f()
        })
          , _ = function() {
            h.locale = "en" === h.locale ? "ko" : "en"
        }
          , b = h
          , v = {
            name: "TermsPopup",
            props: {
                agreeTosAt: String,
                show: {
                    type: Boolean,
                    default: !0
                }
            },
            data: function() {
                return {
                    termsPopup: !1 !== this.show
                }
            },
            computed: {
                sections: function() {
                    return this.$i18n.messages[this.$i18n.locale]["tos-sections"]
                }
            },
            methods: {
                askAgain: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        var n;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return e.next = 2,
                                    t.$store.dispatch("dialog/confirm", t.$t("exit-confirm"));
                                case 2:
                                    n = e.sent,
                                    n && t.disagree();
                                case 4:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                agree: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return e.next = 2,
                                    t.$store.dispatch("agreeTos");
                                case 2:
                                    return e.next = 4,
                                    t.$store.dispatch("dialog/alert", t.$t("agreed"));
                                case 4:
                                    t.exitTermsPopup(),
                                    t.$router.push("/");
                                case 6:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                disagree: function() {
                    window.location = "about:blank"
                },
                exitTermsPopup: function() {
                    this.termsPopup = !1
                },
                openTermsPopup: function() {
                    this.termsPopup = !0
                },
                changeLocale: _
            }
        }
          , g = v
          , y = (n("774a"),
        n("2877"))
          , k = n("afeb")
          , C = Object(y["a"])(g, c, l, !1, null, "ce55a1d6", null);
        "function" === typeof k["default"] && Object(k["default"])(C);
        var w = C.exports
          , x = n("d4ec")
          , A = n("bee2")
          , O = function() {
            function t() {
                Object(x["a"])(this, t),
                this.loadScript()
            }
            return Object(A["a"])(t, [{
                key: "loadScript",
                value: function() {
                    (function() {
                        var t = window;
                        if (t.ChannelIO)
                            return t.console.error("ChannelIO script included twice.");
                        var e = function t() {
                            t.c(arguments)
                        };
                        function n() {
                            if (!t.ChannelIOInitialized) {
                                t.ChannelIOInitialized = !0;
                                var e = document.createElement("script");
                                e.type = "text/javascript",
                                e.async = !0,
                                e.src = "https://cdn.channel.io/plugin/ch-plugin-web.js";
                                var n = document.getElementsByTagName("script")[0];
                                n.parentNode && n.parentNode.insertBefore(e, n)
                            }
                        }
                        e.q = [],
                        e.c = function(t) {
                            e.q.push(t)
                        }
                        ,
                        t.ChannelIO = e,
                        "complete" === document.readyState ? n() : (t.addEventListener("DOMContentLoaded", n),
                        t.addEventListener("load", n))
                    }
                    )()
                }
            }, {
                key: "boot",
                value: function(t, e) {
                    window.ChannelIO("boot", t, e)
                }
            }, {
                key: "shutdown",
                value: function() {
                    window.ChannelIO("shutdown")
                }
            }, {
                key: "showMessenger",
                value: function() {
                    window.ChannelIO("showMessenger")
                }
            }, {
                key: "hideMessenger",
                value: function() {
                    window.ChannelIO("hideMessenger")
                }
            }, {
                key: "openChat",
                value: function(t, e) {
                    window.ChannelIO("openChat", t, e)
                }
            }, {
                key: "track",
                value: function(t, e) {
                    window.ChannelIO("track", t, e)
                }
            }, {
                key: "onShowMessenger",
                value: function(t) {
                    window.ChannelIO("onShowMessenger", t)
                }
            }, {
                key: "onHideMessenger",
                value: function(t) {
                    window.ChannelIO("onHideMessenger", t)
                }
            }, {
                key: "onBadgeChanged",
                value: function(t) {
                    window.ChannelIO("onBadgeChanged", t)
                }
            }, {
                key: "onChatCreated",
                value: function(t) {
                    window.ChannelIO("onChatCreated", t)
                }
            }, {
                key: "onFollowUpChanged",
                value: function(t) {
                    window.ChannelIO("onFollowUpChanged", t)
                }
            }, {
                key: "onUrlClicked",
                value: function(t) {
                    window.ChannelIO("onUrlClicked", t)
                }
            }, {
                key: "clearCallbacks",
                value: function() {
                    window.ChannelIO("clearCallbacks")
                }
            }, {
                key: "updateUser",
                value: function(t, e) {
                    window.ChannelIO("updateUser", t, e)
                }
            }, {
                key: "addTags",
                value: function(t, e) {
                    window.ChannelIO("addTags", t, e)
                }
            }, {
                key: "removeTags",
                value: function(t, e) {
                    window.ChannelIO("removeTags", t, e)
                }
            }, {
                key: "setPage",
                value: function(t) {
                    window.ChannelIO("setPage", t)
                }
            }, {
                key: "resetPage",
                value: function() {
                    window.ChannelIO("resetPage")
                }
            }, {
                key: "showChannelButton",
                value: function() {
                    window.ChannelIO("showChannelButton")
                }
            }, {
                key: "hideChannelButton",
                value: function() {
                    window.ChannelIO("hideChannelButton")
                }
            }, {
                key: "setAppearance",
                value: function(t) {
                    window.ChannelIO("setAppearance", t)
                }
            }]),
            t
        }()
          , S = new O
          , $ = {
            name: "TheFooter",
            components: {
                TermsPopup: w
            },
            data: function() {
                return {
                    isChannelOpen: !1
                }
            },
            computed: {
                agreeTosAt: function() {
                    var t;
                    return null === (t = this.$store.state.auth.userProfile) || void 0 === t ? void 0 : t.agree_terms_of_service_at
                }
            },
            methods: {
                openChannelService: function() {
                    var t, e;
                    (this.isChannelOpen = !this.isChannelOpen,
                    this.isChannelOpen) ? (S.updateUser({
                        profile: {
                            name: null === (t = this.$store.state.auth.userProfile) || void 0 === t ? void 0 : t.nickname,
                            email: null === (e = this.$store.state.auth.userProfile) || void 0 === e ? void 0 : e.email
                        }
                    }),
                    S.showMessenger()) : S.hideMessenger()
                }
            }
        }
          , j = $
          , T = (n("bdb8"),
        n("2e05"))
          , E = Object(y["a"])(j, s, r, !1, null, "2dcae86f", null);
        "function" === typeof T["default"] && Object(T["default"])(E);
        var I = E.exports
          , P = {
            name: "App",
            components: {
                TheFooter: I
            },
            created: function() {
                var t = this;
                this.$Progress.start(),
                this.$router.beforeEach((function(e, n, a) {
                    if (void 0 !== e.meta.progress) {
                        var i = e.meta.progress;
                        t.$Progress.parseMeta(i)
                    }
                    t.$Progress.start(),
                    a()
                }
                )),
                this.$router.afterEach((function(e, n) {
                    t.$Progress.finish()
                }
                )),
                S.boot({
                    pluginKey: "43f4006d-68a4-4edd-a9ad-7665911f9b51",
                    hideChannelButtonOnBoot: !0
                })
            },
            mounted: function() {
                var t = this;
                this.$Progress.finish(),
                window.addEventListener("beforeinstallprompt", (function(t) {
                    t.preventDefault()
                }
                )),
                window.addEventListener("appinstalled", (function() {
                    t.$store.commit("setPWAPrompt", null)
                }
                ))
            }
        }
          , N = P
          , R = (n("5c0b"),
        Object(y["a"])(N, i, o, !1, null, null, null))
          , B = R.exports
          , L = n("2909")
          , D = (n("99af"),
        n("8c4f"))
          , U = (n("9911"),
        n("5530"))
          , M = (n("7db0"),
        n("d81d"),
        n("2f62"))
          , q = n("58ca")
          , z = n("53ca")
          , K = (n("d9e2"),
        n("bc3a"))
          , W = n.n(K)
          , H = n("b85c");
        n("1276"),
        n("498a"),
        n("2ca0");
        function F(t) {
            if (!document.cookie || "" === document.cookie)
                return null;
            var e, n = Object(H["a"])(document.cookie.split(";"));
            try {
                for (n.s(); !(e = n.n()).done; ) {
                    var a = e.value
                      , i = a.trim();
                    if (i.startsWith("".concat(t, "=")))
                        return decodeURIComponent(i.substring(t.length + 1))
                }
            } catch (o) {
                n.e(o)
            } finally {
                n.f()
            }
            return null
        }
        var V = n("3835")
          , Q = (n("4d90"),
        n("25f0"),
        n("a15b"),
        n("b64b"),
        n("3683"))
          , J = n("b166")
          , G = n("9a80")
          , Y = n("d146")
          , Z = n("8c6f")
          , X = n("ab5d")
          , tt = n("8923")
          , et = function(t, e) {
            var n = new Date
              , a = new Date(t)
              , i = "ko" === e ? X["a"] : tt["a"];
            return Object(Q["a"])(n, a) >= 7 ? Object(J["a"])(a, "PP", {
                locale: i
            }) : Object(G["a"])(n, a) >= 24 ? Object(Y["a"])(a, n, {
                unit: "day",
                locale: i,
                addSuffix: !0
            }) : Object(Z["a"])(n, a) >= 60 ? Object(Y["a"])(a, n, {
                unit: "hour",
                locale: i,
                addSuffix: !0
            }) : Object(Y["a"])(a, n, {
                unit: "minute",
                roundingMethod: "ceil",
                locale: i,
                addSuffix: !0
            })
        }
          , nt = function(t) {
            var e = new Date(t)
              , n = e.getFullYear()
              , a = e.getMonth() + 1
              , i = e.getDate()
              , o = e.getHours()
              , s = e.getMinutes()
              , r = function(t) {
                return t.toString().padStart(2, "0")
            }
              , c = [a, i, o, s].map(r)
              , l = Object(V["a"])(c, 4)
              , u = l[0]
              , d = l[1]
              , p = l[2]
              , m = l[3];
            return "".concat(n, ".").concat(u, ".").concat(d, " ").concat(p, ":").concat(m)
        }
          , at = function(t) {
            var e = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : null;
            return null === e ? Object(L["a"])(Array(t).keys()).map((function(t) {
                return t + 1
            }
            )) : t < e ? Object(L["a"])(Array(e - t + 1).keys()).map((function(e) {
                return e + t
            }
            )) : t > e ? Object(L["a"])(Array(t - e + 1).keys()).reverse().map((function(t) {
                return t + e
            }
            )) : [t]
        }
          , it = function(t) {
            return Object.keys(t).map((function(e) {
                return "".concat(e, "=").concat(t[e])
            }
            )).join("&")
        }
          , ot = function(t) {
            return Object.keys(t).reduce((function(e, n) {
                var a = t[n];
                return Array.isArray(a) ? e.push.apply(e, Object(L["a"])(a)) : e.push(a.toString()),
                e
            }
            ), []).join("\n")
        }
          , st = function() {
            return Object({
                VUE_APP_FIREBASE_VAPID_KEY: "BI6O1A1hoeMXc-Gq_OfJZHloB12K-an9ot40gRasDMQh7f3rMHrSzYCXvOLyS5NMDB0kdX5l9FCNxuv6P11vDKY",
                VUE_APP_FIREBASE_CONFIG: '{"apiKey":"AIzaSyDfW_kcVWar6R2QUeZp-SNtbZ4Ue1iKCnU","authDomain":"newara-dev.firebaseapp.com","projectId":"newara-dev","storageBucket":"newara-dev.appspot.com","messagingSenderId":"529803233099","appId":"1:529803233099:web:3534e772c4b4e17ae74ace"}',
                VUE_APP_API_MODE: "development",
                VUE_APP_CHANNEL_PLUGIN_KEY: "43f4006d-68a4-4edd-a9ad-7665911f9b51",
                NODE_ENV: "production",
                BASE_URL: "/"
            }).VUE_APP_API_HOST ? Object({
                VUE_APP_FIREBASE_VAPID_KEY: "BI6O1A1hoeMXc-Gq_OfJZHloB12K-an9ot40gRasDMQh7f3rMHrSzYCXvOLyS5NMDB0kdX5l9FCNxuv6P11vDKY",
                VUE_APP_FIREBASE_CONFIG: '{"apiKey":"AIzaSyDfW_kcVWar6R2QUeZp-SNtbZ4Ue1iKCnU","authDomain":"newara-dev.firebaseapp.com","projectId":"newara-dev","storageBucket":"newara-dev.appspot.com","messagingSenderId":"529803233099","appId":"1:529803233099:web:3534e772c4b4e17ae74ace"}',
                VUE_APP_API_MODE: "development",
                VUE_APP_CHANNEL_PLUGIN_KEY: "43f4006d-68a4-4edd-a9ad-7665911f9b51",
                NODE_ENV: "production",
                BASE_URL: "/"
            }).VUE_APP_API_HOST : "https://newara.dev.sparcs.org"
        }()
          , rt = "".concat(st, "/api/")
          , ct = W.a.create({
            baseURL: rt,
            withCredentials: !0
        });
        ct.interceptors.request.use((function(t) {
            return t.headers["X-CSRFToken"] = F("csrftoken"),
            t
        }
        ), (function(t) {
            return t
        }
        )),
        ct.interceptors.response.use((function(t) {
            return t
        }
        ), (function(t) {
            return t.response && (401 === t.response.status ? Nr.push("/login") : 404 === t.response.status ? Nr.push("/404") : 418 === t.response.status ? Nr.push("/tos") : 410 === t.response.status && Nr.push("/410"),
            "object" === Object(z["a"])(t.response.data) && (t.apierr = t.message = ot(t.response.data))),
            Promise.reject(t)
        }
        ));
        var lt = ct
          , ut = function() {
            return lt.get("home/").then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , dt = (n("3ca3"),
        function(t) {
            var e = t.postId
              , n = t.context
              , a = void 0 === n ? {} : n;
            return lt.get("articles/".concat(e, "/?").concat(it(a))).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
        )
          , pt = function(t) {
            var e = t.boardId
              , n = t.newArticle;
            return lt.post("articles/", Object(U["a"])(Object(U["a"])({}, n), {}, {
                parent_board: e
            })).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , mt = function(t) {
            var e = t.postId
              , n = t.newArticle;
            return lt.put("articles/".concat(e, "/"), Object(U["a"])({}, n)).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , ft = function(t) {
            return lt.post("scraps/", {
                parent_article: t
            }).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , ht = function(t) {
            return lt.delete("scraps/".concat(t, "/")).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , _t = function(t, e, n) {
            return lt.post("reports/", {
                parent_article: t,
                type: e,
                content: n
            }).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , bt = function(t) {
            return lt.delete("articles/".concat(t, "/")).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , vt = function(t, e) {
            return lt.post("articles/".concat(t, "/").concat(e, "/")).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , gt = function(t) {
            var e = t.commentId
              , n = t.context;
            return lt.get("comments/".concat(e, "/?").concat(it(n))).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , yt = function(t) {
            return lt.post("comments/", Object(U["a"])(Object(U["a"])({}, t), {}, {
                attachment: null
            })).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , kt = function(t, e) {
            return lt.patch("comments/".concat(t, "/"), Object(U["a"])({}, e)).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Ct = function(t, e) {
            return lt.post("comments/".concat(t, "/").concat(e, "/")).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , wt = function(t, e, n) {
            return lt.post("reports/", {
                parent_comment: t,
                type: e,
                content: n
            }).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , xt = function(t) {
            return lt.delete("comments/".concat(t, "/")).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , At = function(t) {
            var e = function(t) {
                var e = new FormData;
                return e.append("file", t),
                e
            }
              , n = {
                headers: {
                    "Content-Type": "multipart/form-data"
                }
            };
            return Array.isArray(t) ? Promise.all(t.map((function(t) {
                return lt.post("attachments/", e(t), n)
            }
            ))) : lt.post("attachments/", e(t), n)
        }
          , Ot = function() {
            return lt.get("me").then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , St = function(t) {
            return lt.patch("fcm_token/update", {
                token: t
            }).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , $t = function(t) {
            return lt.patch("fcm_token/delete", {
                token: t
            }).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , jt = function(t) {
            return lt.get("user_profiles/".concat(t, "/")).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Tt = function(t, e) {
            var n = e.nickname
              , a = e.picture
              , i = e.sexual
              , o = e.social
              , s = new FormData;
            return s.append("nickname", n),
            s.append("see_sexual", i),
            s.append("see_social", o),
            a instanceof File && s.append("picture", a),
            lt.patch("user_profiles/".concat(t, "/"), s, {
                headers: {
                    "Content-Type": "multipart/form-data"
                }
            })
        }
          , Et = function(t) {
            return lt.post("/blocks/", {
                user: t
            })
        }
          , It = function(t) {
            return lt.post("/blocks/without_id/", {
                blocked: t
            })
        }
          , Pt = function(t) {
            var e = t.query.page
              , n = {};
            return e && (n.page = e),
            lt.get("notifications/?".concat(it(n))).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Nt = function(t) {
            var e = t.query.page
              , n = {};
            return e && (n.page = e),
            lt.get("notifications/?".concat(it(n), "&is_read=0")).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Rt = function(t) {
            return lt.post("notifications/".concat(t, "/read/")).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Bt = function() {
            return lt.post("notifications/read_all/").then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Lt = function() {
            return lt.get("blocks/").then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Dt = function(t) {
            return lt.delete("blocks/".concat(t, "/"))
        }
          , Ut = function(t, e) {
            return lt.patch("user_profiles/".concat(t, "/"), {
                extra_preferences: {
                    darkMode: e
                }
            }).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Mt = function(t) {
            return lt.patch("/user_profiles/".concat(t, "/agree_terms_of_service/")).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , qt = function(t) {
            return lt.delete("/users/".concat(t, "/sso_logout/")).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , zt = (n("4de4"),
        function() {
            return lt.get("boards/").then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
        )
          , Kt = function() {
            return lt.get("board_groups/").then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Wt = function() {
            var t = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {}
              , e = t.boardId
              , n = t.query
              , a = t.page
              , i = t.pageSize
              , o = t.topicId
              , s = t.username
              , r = t.ordering
              , c = t.filter
              , l = {};
            return e && (Array.isArray(e) ? l.parent_board__in = e.join(",") : l.parent_board = e),
            o && (l.parent_topic = o),
            r && (l.ordering = r),
            n && (l.main_search__contains = n),
            c && (void 0 !== c.communication_article__school_response_status ? l.communication_article__school_response_status = c.communication_article__school_response_status : void 0 !== c.communication_article__school_response_status__lt && (l.communication_article__school_response_status__lt = c.communication_article__school_response_status__lt)),
            a && (l.page = a),
            i && (l.page_size = i),
            s && (l.created_by = s),
            lt.get("articles/?".concat(it(l))).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Ht = function() {
            var t = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {}
              , e = t.query
              , n = t.page
              , a = t.pageSize
              , i = {};
            return e && (i.main_search__contains = e),
            n && (i.page = n),
            a && (i.page_size = a),
            lt.get("scraps/?".concat(it(i))).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Ft = function() {
            return Ht.apply(void 0, arguments).then((function(t) {
                return Object(U["a"])(Object(U["a"])({}, t), {}, {
                    results: t.results && t.results.map((function(t) {
                        var e = t.parent_article;
                        return e
                    }
                    ))
                })
            }
            ))
        }
          , Vt = function() {
            var t = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {}
              , e = t.query
              , n = t.page
              , a = t.pageSize
              , i = {};
            return e && (i.main_search__contains = e),
            n && (i.page = n),
            a && (i.page_size = a),
            lt.get("articles/recent/?".concat(it(i))).then((function(t) {
                var e = t.data;
                return e
            }
            ))
        }
          , Qt = function(t) {
            localStorage.darkMode = t;
            var e = document.documentElement.classList;
            t ? e.add("dark") : e.remove("dark")
        }
          , Jt = {
            state: {
                authState: !1,
                userProfile: {}
            },
            getters: {
                isLoggedIn: function(t) {
                    var e = t.authState;
                    return e
                },
                userId: function(t) {
                    var e = t.userProfile.user;
                    return e
                },
                hasFetched: function(t) {
                    var e = t.userProfile;
                    return 0 !== Object.keys(e).length
                },
                userNickname: function(t) {
                    var e = t.userProfile.nickname;
                    return e
                },
                userPicture: function(t) {
                    var e = t.userProfile.picture;
                    return e
                },
                userConfig: function(t) {
                    var e = t.userProfile
                      , n = e.see_sexual
                      , a = e.see_social;
                    return {
                        sexual: n,
                        social: a
                    }
                },
                userActivity: function(t) {
                    var e = t.userProfile
                      , n = e.num_articles
                      , a = e.num_comments
                      , i = e.num_positive_votes;
                    return {
                        articles: n,
                        comments: a,
                        positiveVotes: i
                    }
                },
                userEmail: function(t) {
                    var e = t.userProfile.sso_user_info.email;
                    return e
                },
                isDarkModeEnabled: function(t) {
                    var e = t.userProfile;
                    return e.extra_preferences && e.extra_preferences.darkMode
                },
                isCommunicationAdmin: function(t) {
                    var e = t.userProfile;
                    return 6 === e.group
                }
            },
            mutations: {
                setUserProfile: function(t, e) {
                    var n = e.extra_preferences && e.extra_preferences.darkMode;
                    Qt(n),
                    t.userProfile = e
                },
                setAuthState: function(t, e) {
                    t.authState = e
                }
            },
            actions: {
                fetchMe: function(t) {
                    return Object(u["a"])(p.a.mark((function e() {
                        var n, a, i, o;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    if (n = t.commit,
                                    a = t.getters,
                                    i = a.hasFetched,
                                    e.prev = 2,
                                    i) {
                                        e.next = 9;
                                        break
                                    }
                                    return e.t0 = n,
                                    e.next = 7,
                                    Ot();
                                case 7:
                                    e.t1 = e.sent,
                                    (0,
                                    e.t0)("setUserProfile", e.t1);
                                case 9:
                                    o = a.userId,
                                    n("setAuthState", void 0 !== o),
                                    e.next = 16;
                                    break;
                                case 13:
                                    e.prev = 13,
                                    e.t2 = e["catch"](2),
                                    n("setAuthState", !1);
                                case 16:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e, null, [[2, 13]])
                    }
                    )))()
                },
                agreeTos: function(t) {
                    return Object(u["a"])(p.a.mark((function e() {
                        var n, a;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return n = t.dispatch,
                                    a = t.getters.userId,
                                    e.next = 3,
                                    Mt(a);
                                case 3:
                                    return e.abrupt("return", n("fetchMe"));
                                case 4:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                toggleDarkMode: function(t) {
                    return Object(u["a"])(p.a.mark((function e() {
                        var n, a;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return n = t.commit,
                                    a = t.getters.isDarkModeEnabled,
                                    e.t0 = n,
                                    e.next = 4,
                                    Ut(!a);
                                case 4:
                                    e.t1 = e.sent,
                                    (0,
                                    e.t0)("setUserProfile", e.t1);
                                case 6:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                }
            }
        }
          , Gt = (n("fb6a"),
        n("c740"),
        n("a434"),
        {
            namespaced: !0,
            state: {
                dialogs: []
            },
            mutations: {
                addDialog: function(t, e) {
                    e.id = Math.random().toString(36).slice(2),
                    t.dialogs.push(e)
                },
                removeDialog: function(t, e) {
                    "string" === typeof e && (e = {
                        id: e
                    });
                    var n = t.dialogs.findIndex((function(t) {
                        return t.id === e.id
                    }
                    ));
                    if (!(n < 0)) {
                        var a = t.dialogs[n];
                        a.callback && ("report" === a.type ? a.callback({
                            result: e.value,
                            selection: e.chip_selection
                        }) : a.callback(e.value)),
                        t.dialogs.splice(n, 1)
                    }
                }
            },
            actions: {
                createDialog: function(t, e) {
                    t.state;
                    var n = t.commit;
                    n("addDialog", e),
                    e.timeout && setTimeout((function() {
                        n("removeDialog", e.id)
                    }
                    ), e.timeout)
                },
                alert: function(t, e) {
                    var n = t.dispatch;
                    return "string" === typeof e && (e = {
                        text: e
                    }),
                    new Promise((function(t) {
                        e.type || (e.type = "info"),
                        e.callback = t,
                        n("createDialog", e)
                    }
                    ))
                },
                confirm: function(t, e) {
                    var n = t.dispatch;
                    return "string" === typeof e && (e = {
                        text: e
                    }),
                    new Promise((function(t) {
                        e.type = "confirm",
                        e.callback = t,
                        n("createDialog", e)
                    }
                    ))
                },
                report: function(t, e) {
                    var n = t.dispatch;
                    return "string" === typeof e && (e = {
                        text: e
                    }),
                    new Promise((function(t) {
                        e.type = "report",
                        e.callback = t,
                        n("createDialog", e)
                    }
                    ))
                },
                toast: function(t, e) {
                    var n = t.dispatch;
                    return "string" === typeof e && (e = {
                        text: e
                    }),
                    e.timeout = 2e3,
                    e.toast = !0,
                    n("alert", e)
                }
            }
        })
          , Yt = {
            IDLE: "idle",
            FETCHING: "fetching",
            ENDING: "ending",
            ERROR: "error"
        }
          , Zt = {
            namespaced: !0,
            state: {
                status: Yt.IDLE,
                progress: 0
            },
            getters: {
                isFetching: function(t) {
                    var e = t.status;
                    return e === Yt.FETCHING || e === Yt.ENDING
                }
            },
            mutations: {
                updateError: function(t, e) {
                    t.status = Yt.ERROR
                },
                endError: function(t) {
                    t.status = Yt.IDLE
                },
                startProgress: function(t) {
                    t.status = Yt.FETCHING,
                    t.progress = .05
                },
                updateProgress: function(t, e) {
                    t.status === Yt.FETCHING && (t.progress = e)
                },
                preEndProgress: function(t) {
                    t.status = Yt.ENDING,
                    t.progress = 1
                },
                endProgress: function(t) {
                    t.status = Yt.IDLE,
                    t.progress = 0
                }
            },
            actions: {
                showError: function(t, e) {
                    var n = t.commit
                      , a = t.dispatch;
                    n("updateError"),
                    setTimeout((function() {
                        n("endError")
                    }
                    ), 2e3),
                    a("dialog/toast", {
                        type: "error",
                        text: e
                    }, {
                        root: !0
                    })
                },
                startProgress: function(t) {
                    var e = t.commit;
                    e("startProgress"),
                    setTimeout((function() {
                        e("updateProgress", .1)
                    }
                    ), 100),
                    setTimeout((function() {
                        e("updateProgress", .25)
                    }
                    ), 200),
                    setTimeout((function() {
                        e("updateProgress", .55)
                    }
                    ), 300)
                },
                endProgress: function(t) {
                    var e = t.commit;
                    e("preEndProgress"),
                    setTimeout((function() {
                        e("endProgress")
                    }
                    ), 300)
                }
            }
        };
        a["a"].use(M["a"]),
        a["a"].use(q["a"]);
        var Xt = new M["a"].Store({
            modules: {
                auth: Jt,
                dialog: Gt,
                fetch: Zt
            },
            state: {
                boardList: [],
                boardGroups: [],
                recentPosts: [],
                archivedPosts: [],
                PWAPrompt: null
            },
            getters: {
                hasFetchedBoardList: function(t) {
                    var e = t.boardList;
                    return 0 !== e.length
                },
                getIdBySlug: function(t) {
                    var e = t.boardList;
                    return function(t) {
                        var n;
                        return null === (n = e.find((function(e) {
                            return e.slug === t
                        }
                        ))) || void 0 === n ? void 0 : n.id
                    }
                },
                getBoardById: function(t) {
                    var e = t.boardList;
                    return function(t) {
                        return e.find((function(e) {
                            return e.id === t
                        }
                        ))
                    }
                },
                getSlugById: function(t) {
                    var e = t.boardList;
                    return function(t) {
                        var n;
                        return null === (n = e.find((function(e) {
                            return e.id === t
                        }
                        ))) || void 0 === n ? void 0 : n.slug
                    }
                },
                getNameById: function(t) {
                    var e = t.boardList;
                    return function(t, n) {
                        var a = e.find((function(e) {
                            return e.id === t
                        }
                        ));
                        return a ? a["".concat(n, "_name")] : b.t("all", n)
                    }
                },
                getBannerDescriptionById: function(t) {
                    var e = t.boardList;
                    return function(t, n) {
                        var a = e.find((function(e) {
                            return e.id === t
                        }
                        ))
                          , i = a ? a["".concat(n, "_banner_description")] : "";
                        return null === i ? "" : i
                    }
                },
                getBannerImageById: function(t) {
                    var e = t.boardList;
                    return function(t) {
                        var n = e.find((function(e) {
                            return e.id === t
                        }
                        ));
                        return n ? n.banner_image : ""
                    }
                },
                PWAPrompt: function(t) {
                    var e = t.PWAPrompt;
                    return e
                }
            },
            mutations: {
                setBoardList: function(t, e) {
                    t.boardList = e
                },
                setBoardGroups: function(t, e) {
                    t.boardGroups = e.map((function(t) {
                        return Object(U["a"])(Object(U["a"])({}, t), {}, {
                            clicked: !1
                        })
                    }
                    ))
                },
                setRecentPosts: function(t, e) {
                    t.recentPosts = e
                },
                setArchivedPosts: function(t, e) {
                    t.archivedPosts = e
                },
                setPWAPrompt: function(t, e) {
                    t.PWAPrompt = e
                }
            },
            actions: {
                fetchBoardList: function(t) {
                    return Object(u["a"])(p.a.mark((function e() {
                        var n, a, i, o;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    if (n = t.commit,
                                    a = t.getters.hasFetchedBoardList,
                                    a) {
                                        e.next = 10;
                                        break
                                    }
                                    return e.next = 4,
                                    zt();
                                case 4:
                                    return i = e.sent,
                                    n("setBoardList", i),
                                    e.next = 8,
                                    Kt();
                                case 8:
                                    o = e.sent,
                                    n("setBoardGroups", o);
                                case 10:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                fetchRecentPosts: function(t) {
                    return Object(u["a"])(p.a.mark((function e() {
                        var n, a, i;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return n = t.commit,
                                    e.next = 3,
                                    Vt({
                                        pageSize: 5
                                    });
                                case 3:
                                    a = e.sent,
                                    i = a.results,
                                    n("setRecentPosts", i);
                                case 6:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                fetchArchivedPosts: function(t) {
                    return Object(u["a"])(p.a.mark((function e() {
                        var n, a, i;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return n = t.commit,
                                    e.next = 3,
                                    Ft({
                                        pageSize: 5
                                    });
                                case 3:
                                    a = e.sent,
                                    i = a.results,
                                    n("setArchivedPosts", i);
                                case 6:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                }
            }
        })
          , te = function() {
            var t = this
              , e = t.$createElement
              , a = t._self._c || e;
            return a("div", {
                staticClass: "facade"
            }, [a("button", {
                staticClass: "button language-button",
                on: {
                    click: t.changeLocale
                }
            }, [a("i", {
                staticClass: "material-icons"
            }, [t._v("language")]), a("span", {
                staticClass: "is-hidden-touch"
            }, [t._v(t._s(t.$t("lang")))])]), a("div", {
                staticClass: "title"
            }, [a("img", {
                staticClass: "title__logo",
                attrs: {
                    src: n("fbee")
                }
            }), a("div", {
                staticClass: "title__description",
                domProps: {
                    innerHTML: t._s(t.$t("main"))
                }
            })]), a("div", {
                staticClass: "banners"
            }, [a("div", {
                staticClass: "banner login"
            }, [a("div", {
                staticClass: "banner__identity-bar"
            }), a("h1", {
                staticClass: "banner__title"
            }, [t._v(" " + t._s(t.$t("login-title")) + " ")]), a("h2", {
                staticClass: "banner__subtitle",
                domProps: {
                    innerHTML: t._s(t.$t("login-subtitle"))
                }
            }), a("a", {
                staticClass: "button banner__button login__link",
                attrs: {
                    href: t.loginUrl
                }
            }, [a("i", {
                staticClass: "material-icons"
            }, [t._v("login")]), t._v(" " + t._s(t.$t("login")) + " ")])]), a("div", {
                staticClass: "banner"
            }, [a("div", {
                staticClass: "banner__identity-bar"
            }), a("h1", {
                staticClass: "banner__title",
                domProps: {
                    innerHTML: t._s(t.$t("signup-title"))
                }
            }), a("h2", {
                staticClass: "banner__subtitle"
            }, [t._v(" " + t._s(t.$t("signup-subtitle")) + " ")]), a("div", {
                staticClass: "banner__buttons"
            }, [a("a", {
                staticClass: "button banner__button",
                attrs: {
                    href: "https://bit.ly/sso-signup"
                }
            }, [t._v(" " + t._s(t.$t("signup")) + " ")]), a("a", {
                staticClass: "button banner__button",
                attrs: {
                    href: "https://bit.ly/newara-org-signup"
                }
            }, [t._v(" " + t._s(t.$t("apply-organization")) + " ")]), a("a", {
                staticClass: "button banner__button",
                attrs: {
                    href: "https://bit.ly/newara-comp-signup"
                }
            }, [t._v(" " + t._s(t.$t("apply-amenity")) + " ")])])])])])
        }
          , ee = []
          , ne = {
            name: "Facade",
            computed: {
                loginUrl: function() {
                    var t = this.$route.query.next;
                    return "".concat(st, "/api/users/sso_login/?next=").concat(location.protocol, "//").concat(location.host, "/login-handler?link=").concat(t)
                }
            },
            created: function() {
                S.showChannelButton()
            },
            methods: {
                changeLocale: _
            }
        }
          , ae = ne
          , ie = (n("aa71"),
        n("3fc3"))
          , oe = Object(y["a"])(ae, te, ee, !1, null, "034d026a", null);
        "function" === typeof ie["default"] && Object(ie["default"])(oe);
        var se = oe.exports
          , re = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("TheLayout", [n("TermsPopup")], 1)
        }
          , ce = []
          , le = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "layout"
            }, [n("TheNavbar"), n("TheAlertDialogs"), n("div", {
                staticClass: "container"
            }, [n("div", {
                staticClass: "columns",
                class: {
                    "default-columns": t.isColumnLayout
                }
            }, [t._t("aside"), t.isColumnLayout ? [n("div", {
                staticClass: "column"
            }, [t._t("default")], 2)] : [t._t("default")], t._t("aside-right")], 2)])], 1)
        }
          , ue = []
          , de = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "dialogs"
            }, [n("transition-group", {
                attrs: {
                    tag: "div",
                    name: "dialog-fade"
                }
            }, t._l(t.dialogs, (function(t) {
                return n("AlertDialog", {
                    key: t.id,
                    attrs: {
                        dialog: t
                    }
                })
            }
            )), 1), n("transition-group", {
                staticClass: "dialogs__toasts",
                attrs: {
                    tag: "div",
                    name: "toast-fade"
                }
            }, t._l(t.toasts, (function(t) {
                return n("AlertDialog", {
                    key: t.id,
                    attrs: {
                        dialog: t
                    }
                })
            }
            )), 1), n("transition", {
                attrs: {
                    name: "dialog-fade"
                }
            }, [t.needBackdrop ? n("div", {
                staticClass: "dialogs__backdrop",
                on: {
                    click: function(e) {
                        return t.dismiss(t.dialogs[0].id)
                    }
                }
            }) : t._e()])], 1)
        }
          , pe = []
          , me = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "alert-dialog",
                class: {
                    "alert-dialog--toast": t.dialog.toast
                }
            }, [n("div", {
                staticClass: "alert-dialog__icon"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v(t._s(t.iconName))])]), n("div", {
                staticClass: "alert-dialog__content"
            }, [n("div", {
                staticClass: "content-text",
                domProps: {
                    innerHTML: t._s(t.dialog.text)
                }
            })]), "report" === t.dialog.type ? n("div", {
                staticClass: "alert-dialog__chips"
            }, [n("div", {
                staticClass: "alert-dialog__chip"
            }, t._l(Object.keys(t.chips), (function(e) {
                return n("button", {
                    key: e,
                    staticClass: "chip",
                    class: {
                        chip__clicked: t.chips[e]
                    },
                    on: {
                        click: function(n) {
                            return t.chipClick(e)
                        }
                    }
                }, [t._v(" " + t._s(t.$t(e)) + " ")])
            }
            )), 0)]) : t._e(), t.hasButtons ? n("div", {
                staticClass: "alert-dialog__buttons"
            }, ["confirm" === t.dialog.type ? [n("button", {
                staticClass: "alert-dialog__button",
                on: {
                    click: function(e) {
                        return t.dismiss(!1)
                    }
                }
            }, [t._v(" " + t._s(t.dialog.secondary_button || t.$t("cancel")) + " ")]), n("button", {
                staticClass: "alert-dialog__button alert-dialog__button--accent",
                on: {
                    click: function(e) {
                        return t.dismiss(!0)
                    }
                }
            }, [t._v(" " + t._s(t.dialog.primary_button || t.$t("okay")) + " ")])] : "confirmAgree" === t.dialog.type ? [n("button", {
                staticClass: "alert-dialog__button",
                on: {
                    click: function(e) {
                        return t.dismiss(!1)
                    }
                }
            }, [t._v(" " + t._s(t.dialog.secondary_button || t.$t("cancel")) + " ")]), n("button", {
                staticClass: "alert-dialog__button alert-dialog__button--accent",
                class: {
                    "alert-dialog__button--none": t.agreeText !== t.dialog.agreeText
                },
                attrs: {
                    disabled: t.agreeText !== t.dialog.agreeText
                },
                on: {
                    click: function(e) {
                        return t.dismiss(!0)
                    }
                }
            }, [t._v(" " + t._s(t.dialog.primary_button || t.$t("okay")) + " ")])] : "report" === t.dialog.type ? [n("button", {
                staticClass: "alert-dialog__button",
                on: {
                    click: function(e) {
                        return t.dismiss(!1)
                    }
                }
            }, [t._v(" " + t._s(t.dialog.secondary_button || t.$t("cancel")) + " ")]), n("div", {
                staticClass: "dropdown is-hoverable is-up"
            }, [n("div", {
                staticClass: "dropdown-trigger",
                attrs: {
                    disabled: "!isChipClicked"
                },
                on: {
                    click: function() {
                        t.isChipClicked && t.dismiss(!0)
                    }
                }
            }, [n("button", {
                staticClass: "alert-dialog__button alert-dialog__button--accent",
                class: {
                    "alert-dialog__button--none": !t.isChipClicked
                },
                attrs: {
                    "aria-haspopup": "true",
                    "aria-controls": "dropdown-menu_tooltip"
                }
            }, [t._v(" " + t._s(t.dialog.primary_button || t.$t("report")) + " ")])]), n("div", {
                directives: [{
                    name: "show",
                    rawName: "v-show",
                    value: !t.isChipClicked,
                    expression: "!isChipClicked"
                }],
                staticClass: "dropdown-menu",
                attrs: {
                    id: "dropdown-menu_tooltip",
                    role: "menu"
                }
            }, [n("div", {
                staticClass: "dropdown-content"
            }, [n("div", {
                staticClass: "dropdown-item"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("error_outline")]), n("p", [t._v(t._s(t.$t("need-reason-for-report")))])])])])])] : [n("button", {
                staticClass: "alert-dialog__button",
                on: {
                    click: function(e) {
                        return t.dismiss()
                    }
                }
            }, [t._v(" " + t._s(t.dialog.primary_button || t.$t("okay")) + " ")])]], 2) : t._e()])
        }
          , fe = []
          , he = (n("07ac"),
        {
            confirm: "check_circle_outline",
            confirmAgree: "check_circle_outline",
            report: "check_circle_outline",
            error: "error_outline",
            warning: "highlight_off",
            info: "info_outline"
        })
          , _e = {
            name: "AlertDialog",
            props: {
                dialog: {
                    type: Object,
                    required: !0
                }
            },
            data: function() {
                return {
                    chips: {
                        hate_speech: !1,
                        unauthorized_sales_articles: !1,
                        spam: !1,
                        fake_information: !1,
                        defamation: !1,
                        other: !1
                    },
                    agreeText: ""
                }
            },
            computed: {
                isChipClicked: function() {
                    return Object.values(this.chips).some((function(t) {
                        return t
                    }
                    ))
                },
                iconName: function() {
                    return this.dialog.icon || he[this.dialog.type]
                },
                hasButtons: function() {
                    return !this.dialog.toast
                }
            },
            methods: {
                dismiss: function(t) {
                    this.dialog.agreeText && t && this.agreeText !== this.dialog.agreeText || this.$store.commit("dialog/removeDialog", {
                        id: this.dialog.id,
                        value: t,
                        chip_selection: this.chips
                    })
                },
                chipClick: function(t) {
                    this.chips[t] = !this.chips[t]
                }
            }
        }
          , be = _e
          , ve = (n("cdb3"),
        n("ed05"))
          , ge = Object(y["a"])(be, me, fe, !1, null, "99410148", null);
        "function" === typeof ve["default"] && Object(ve["default"])(ge);
        var ye = ge.exports
          , ke = {
            name: "TheAlertDialogs",
            components: {
                AlertDialog: ye
            },
            computed: {
                dialogs: function() {
                    return this.$store.state.dialog.dialogs.filter((function(t) {
                        return !t.toast
                    }
                    ))
                },
                toasts: function() {
                    return this.$store.state.dialog.dialogs.filter((function(t) {
                        return t.toast
                    }
                    ))
                },
                needBackdrop: function() {
                    return this.dialogs.length > 0
                }
            },
            methods: {
                dismiss: function(t) {
                    this.$store.commit("dialog/removeDialog", t)
                }
            }
        }
          , Ce = ke
          , we = (n("2414"),
        Object(y["a"])(Ce, de, pe, !1, null, "3ad8afb2", null))
          , xe = we.exports
          , Ae = function() {
            var t = this
              , e = t.$createElement
              , a = t._self._c || e;
            return a("div", [a("IdentityBar"), a("div", {
                staticClass: "navbar",
                class: {
                    "navbar-shadow": !1
                },
                attrs: {
                    "aria-label": "main",
                    role: "navigation"
                }
            }, [a("div", {
                staticClass: "navbar-brand",
                class: {
                    "navbar-active": t.isMobileMenuActive || t.isMobileAlarmShow
                }
            }, [a("router-link", {
                staticClass: "navbar-item navbar-ara",
                attrs: {
                    to: {
                        name: "home"
                    }
                }
            }, [a("img", {
                staticClass: "ara-logo",
                attrs: {
                    src: n("fbee")
                }
            })]), a("router-link", {
                staticClass: "navbar-item navbar-item--mobile-write is-hidden-desktop",
                attrs: {
                    to: {
                        name: "write",
                        params: {
                            board: t.$route.path
                        }
                    }
                }
            }, [a("i", {
                staticClass: "material-icons write-icon"
            }, [t._v("create")])]), a("a", {
                staticClass: "navbar-item navbar-item--mobile-alarm is-hidden-desktop",
                attrs: {
                    to: {
                        name: "notifications"
                    }
                },
                on: {
                    click: t.toggleMobileAlram
                }
            }, [a("i", {
                staticClass: "material-icons write-icon"
            }, [t._v("notifications")])]), a("a", {
                staticClass: "navbar-burger",
                class: {
                    "is-active": t.isMobileMenuActive
                },
                attrs: {
                    role: "button",
                    "aria-label": "menu",
                    "aria-expanded": "false"
                },
                on: {
                    click: t.toggleMobileMenu
                }
            }, [a("span", {
                attrs: {
                    "aria-hidden": "true"
                }
            }), a("span", {
                attrs: {
                    "aria-hidden": "true"
                }
            }), a("span", {
                attrs: {
                    "aria-hidden": "true"
                }
            })])], 1), a("div", {
                staticClass: "navbar-alarm has-dropdown",
                class: {
                    "navbar-clicked": !t.isMobileAlarmShow
                }
            }, [a("div", {
                staticClass: "navbar-dropdown"
            }, [a("div", {
                staticClass: "alarm-popup"
            }, [t._l(t.showedNotifications, (function(t) {
                return a("AlarmPopupNotifications", {
                    key: t.id,
                    staticClass: "alarm-content",
                    attrs: {
                        notification: t
                    }
                })
            }
            )), a("router-link", {
                staticClass: "alarm-popup-router",
                attrs: {
                    to: {
                        name: "notifications"
                    }
                }
            }, [a("span", [t._v(" " + t._s(t.$t("morealarm")) + " ")])])], 2)])]), a("div", {
                staticClass: "navbar-menu",
                class: {
                    "is-active": t.isMobileMenuActive
                }
            }, [a("div", {
                staticClass: "navbar-start"
            }, [a("router-link", {
                staticClass: "navbar-item",
                attrs: {
                    to: {
                        name: "board"
                    }
                }
            }, [a("span", [t._v(t._s(t.$t("all")))])]), t._l(t.boardGroups, (function(e) {
                return a("div", {
                    key: e.id,
                    staticClass: "navbar-item has-dropdown is-hoverable boardlist"
                }, [e.boards.length <= 1 ? a("router-link", {
                    staticClass: "navbar-item",
                    attrs: {
                        to: {
                            name: "board",
                            params: {
                                boardSlug: "talk"
                            }
                        }
                    }
                }, [a("span", [t._v(t._s(e[[t.$i18n.locale + "_name"]]))])]) : t._e(), e.boards.length > 1 ? a("div", {
                    staticClass: "navbar-item",
                    on: {
                        click: function(n) {
                            return t.click(e.slug)
                        }
                    }
                }, [e.clicked ? a("i", {
                    staticClass: "material-icons is-hidden-desktop"
                }, [t._v("expand_less")]) : a("i", {
                    staticClass: "material-icons is-hidden-desktop"
                }, [t._v("expand_more")]), a("span", [t._v(t._s(e[[t.$i18n.locale + "_name"]]))])]) : t._e(), e.boards.length > 1 ? a("div", {
                    staticClass: "navbar-dropdown",
                    class: {
                        "navbar-clicked": !e.clicked,
                        "is-boxed": !0
                    }
                }, t._l(e.boards, (function(e) {
                    return a("router-link", {
                        key: e.id,
                        staticClass: "navbar-item",
                        attrs: {
                            to: {
                                name: "board",
                                params: {
                                    boardSlug: e.slug
                                }
                            }
                        }
                    }, [a("div", [t._v(t._s(e[t.$i18n.locale + "_name"]))])])
                }
                )), 1) : t._e()], 1)
            }
            ))], 2), a("div", {
                staticClass: "navbar-end"
            }, [a("router-link", {
                staticClass: "navbar-item navbar-item--write is-hidden-touch",
                attrs: {
                    to: {
                        name: "write",
                        params: {
                            board: t.$route.path
                        }
                    }
                }
            }, [a("span", [t._v(t._s(t.$t("write")))])]), a("a", {
                staticClass: "navbar-item",
                attrs: {
                    id: "toggle-language"
                },
                on: {
                    click: t.changeLocale
                }
            }, [t._m(0), a("span", {
                staticClass: "is-hidden-desktop"
            }, [t._v(" " + t._s(t.$t("language")) + " ")])]), a("div", {
                directives: [{
                    name: "clickOutside",
                    rawName: "v-clickOutside",
                    value: t.closeAlram,
                    expression: "closeAlram"
                }],
                staticClass: "navbar-item has-dropdown is-hidden-touch is-active"
            }, [a("div", {
                staticClass: "alarmicon",
                on: {
                    click: t.toggleAlram
                }
            }, [a("span", {
                staticClass: "icon",
                class: {
                    "unread-noti": t.isUnreadNotificationExist
                },
                attrs: {
                    "data-badge": " "
                }
            }, [a("i", {
                staticClass: "material-icons"
            }, [t._v("notifications")])])]), t.isAlramShow ? a("div", {
                staticClass: "alarm-popup navbar-dropdown is-hidden-touch",
                class: {
                    "is-boxed": t.isHome
                }
            }, [t._l(t.showedNotifications, (function(t) {
                return a("AlarmPopupNotifications", {
                    key: t.id,
                    staticClass: "alarm-content",
                    attrs: {
                        notification: t
                    }
                })
            }
            )), a("router-link", {
                staticClass: "alarm-popup-router",
                attrs: {
                    to: {
                        name: "notifications"
                    }
                }
            }, [a("span", [t._v(" " + t._s(t.$t("morealarm")) + " ")])])], 2) : t._e()]), a("div", {
                staticClass: "navbar-item has-dropdown is-hoverable"
            }, [a("router-link", {
                staticClass: "user",
                attrs: {
                    to: t.isMobileMenuActive ? {
                        name: "my-info"
                    } : t.$route.fullPath
                }
            }, [a("img", {
                staticClass: "picture-url",
                attrs: {
                    src: t.userPicture
                }
            }), a("span", {
                staticClass: "username"
            }, [t._v(t._s(t.userNickname))])]), a("div", {
                staticClass: "navbar-dropdown is-hidden-touch",
                class: {
                    "is-boxed": t.isHome
                }
            }, [a("router-link", {
                staticClass: "navbar-item",
                attrs: {
                    to: {
                        name: "my-info"
                    }
                }
            }, [a("span", [t._v(t._s(t.$t("my-page")))])]), a("router-link", {
                staticClass: "navbar-item logout",
                attrs: {
                    to: {
                        name: "logout-handler"
                    }
                }
            }, [a("span", [t._v(t._s(t.$t("logout")))])])], 1)], 1), a("router-link", {
                staticClass: "navbar-item is-hidden-desktop",
                attrs: {
                    to: {
                        name: "logout-handler"
                    }
                }
            }, [t._v(" " + t._s(t.$t("logout")) + " ")])], 1)])])], 1)
        }
          , Oe = [function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("span", {
                staticClass: "icon"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("language")])])
        }
        ]
          , Se = (n("b0c0"),
        function() {
            var t = this
              , e = t.$createElement
              , a = t._self._c || e;
            return a("div", {
                staticClass: "identity-bar"
            }, [a("transition", {
                attrs: {
                    name: "fadeHeight",
                    mode: "out-in"
                }
            }, [t.PWAPrompt ? a("div", {
                staticClass: "identity-bar-noti"
            }, [a("div", {
                staticClass: "img-container"
            }, [a("img", {
                attrs: {
                    src: n("faeb"),
                    alt: "s"
                }
            })]), a("div", {
                staticClass: "texts"
            }, [a("div", {
                staticClass: "title"
            }, [t._v(" " + t._s(t.$t("title")) + " ")]), a("div", {
                staticClass: "desc"
            }, [t._v(" " + t._s(t.$t("subtitle")) + " ")])]), a("button", {
                on: {
                    click: t.installPWA
                }
            }, [t._v(" " + t._s(t.$t("install")) + " ")]), a("button", {
                on: {
                    click: t.closeInstall
                }
            }, [t._v(" " + t._s(t.$t("close")) + " ")])]) : t._e()])], 1)
        }
        )
          , $e = []
          , je = {
            name: "IdentityBar",
            computed: Object(U["a"])({}, Object(M["c"])(["PWAPrompt"])),
            methods: {
                installPWA: function() {
                    this.PWAPrompt.prompt()
                },
                closeInstall: function() {
                    this.$store.commit("setPWAPrompt", null)
                }
            }
        }
          , Te = je
          , Ee = (n("2521"),
        n("7b11"))
          , Ie = Object(y["a"])(Te, Se, $e, !1, null, "26a9f0a4", null);
        "function" === typeof Ee["default"] && Object(Ee["default"])(Ie);
        var Pe = Ie.exports
          , Ne = n("26b9")
          , Re = {
            color: "#f4b9b9",
            failedColor: "#b22020",
            thickness: "5px",
            transition: {
                speed: "0.1s",
                opacity: "0.3s",
                termination: 300
            },
            autoRevert: !0,
            location: "top"
        };
        a["a"].use(Ne, Re);
        var Be = new a["a"]
          , Le = Be
          , De = function() {
            var t = Object(u["a"])(p.a.mark((function t(e, n) {
                var a;
                return p.a.wrap((function(t) {
                    while (1)
                        switch (t.prev = t.next) {
                        case 0:
                            return Xt.dispatch("fetch/startProgress"),
                            t.prev = 1,
                            t.next = 4,
                            Promise.all(e);
                        case 4:
                            return a = t.sent,
                            Xt.dispatch("fetch/endProgress"),
                            t.abrupt("return", a);
                        case 9:
                            throw t.prev = 9,
                            t.t0 = t["catch"](1),
                            n && Xt.dispatch("dialog/toast", {
                                type: "error",
                                text: b.t(n) + (t.t0.apierr ? "\n" + t.t0.apierr : "")
                            }),
                            Le.$Progress.fail(),
                            Xt.dispatch("fetch/endProgress"),
                            t.t0;
                        case 15:
                        case "end":
                            return t.stop()
                        }
                }
                ), t, null, [[1, 9]])
            }
            )));
            return function(e, n) {
                return t.apply(this, arguments)
            }
        }()
          , Ue = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("router-link", {
                staticClass: "noti",
                class: {
                    "is-read": t.isRead
                },
                attrs: {
                    to: {
                        name: "post",
                        params: {
                            postId: t.notification.related_article.id,
                            notiId: t.notification.id
                        },
                        query: {
                            from_view: "all"
                        }
                    }
                }
            }, [n("i", {
                staticClass: "noti__icon material-icons-outlined"
            }, [t._v("chat")]), n("div", {
                staticClass: "noti__container"
            }, [n("h3", {
                staticClass: "noti__title"
            }, [t._v(" " + t._s(t.notification.content) + " ")]), n("div", {
                staticClass: "noti__related"
            }, [n("div", {
                staticClass: "noti__subcomment-container"
            }, [n("div", [t._v(" [" + t._s(t.boardName) + "] " + t._s(t.relatedArticle) + " "), t.isSubcomment ? n("p", {
                staticClass: "noti__content"
            }, [t._v(" [" + t._s(t.$t("comment")) + "] " + t._s(t.relatedComment) + " ")]) : t._e()])])])])])
        }
          , Me = []
          , qe = a["a"].extend({
            name: "AlarmPopupNotifications",
            props: {
                notification: {
                    type: Object,
                    required: !0
                }
            },
            computed: {
                isRead: function() {
                    return this.notification.is_read
                },
                isSubcomment: function() {
                    return "comment_commented" === this.notification.type
                },
                relatedArticle: function() {
                    return this.notification.related_article.title
                },
                relatedComment: function() {
                    var t;
                    return null === (t = this.notification.related_comment) || void 0 === t ? void 0 : t.content
                },
                boardName: function() {
                    return this.$store.getters.getNameById(this.notification.related_article.parent_board, this.$i18n.locale)
                }
            },
            methods: {
                timeago: et
            }
        })
          , ze = qe
          , Ke = (n("5774"),
        n("bf52"))
          , We = Object(y["a"])(ze, Ue, Me, !1, null, "27c35477", null);
        "function" === typeof Ke["default"] && Object(Ke["default"])(We);
        var He = We.exports
          , Fe = n("2ef0")
          , Ve = n.n(Fe)
          , Qe = n("260b")
          , Je = n("741f")
          , Ge = JSON.parse('{"apiKey":"AIzaSyDfW_kcVWar6R2QUeZp-SNtbZ4Ue1iKCnU","authDomain":"newara-dev.firebaseapp.com","projectId":"newara-dev","storageBucket":"newara-dev.appspot.com","messagingSenderId":"529803233099","appId":"1:529803233099:web:3534e772c4b4e17ae74ace"}')
          , Ye = Qe["a"](Ge)
          , Ze = !1
          , Xe = !0
          , tn = function() {
            var t = Object(u["a"])(p.a.mark((function t() {
                return p.a.wrap((function(t) {
                    while (1)
                        switch (t.prev = t.next) {
                        case 0:
                            if (!Xe) {
                                t.next = 2;
                                break
                            }
                            return t.abrupt("return");
                        case 2:
                            !Ze && "Notification"in window && Notification.requestPermission().then((function(t) {
                                "granted" === t ? Object(Je["b"])(Object(Je["a"])(Ye), {
                                    vapidKey: "BI6O1A1hoeMXc-Gq_OfJZHloB12K-an9ot40gRasDMQh7f3rMHrSzYCXvOLyS5NMDB0kdX5l9FCNxuv6P11vDKY"
                                }).then((function(t) {
                                    t ? (St(t),
                                    Ze = !0) : console.log("[Notification] No registration token available. Request permission to generate one.")
                                }
                                )).catch((function(t) {
                                    console.log("[Notification] An error occurred while retrieving token. ", t)
                                }
                                )) : (alert("권한 허용을 해 주셔야 PUSH 알림을 받으실 수 있습니다."),
                                Ze = !0)
                            }
                            ));
                        case 3:
                        case "end":
                            return t.stop()
                        }
                }
                ), t)
            }
            )));
            return function() {
                return t.apply(this, arguments)
            }
        }()
          , en = function(t) {
            Xe || Object(Je["c"])(Object(Je["a"])(Ye), (function(e) {
                navigator.serviceWorker.getRegistration("/firebase-cloud-messaging-push-scope").then(function() {
                    var n = Object(u["a"])(p.a.mark((function n(a) {
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    return n.next = 2,
                                    t.reloadNotification();
                                case 2:
                                    t.$store.dispatch("dialog/toast", e.notification.title + "\n" + e.notification.body);
                                case 3:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n)
                    }
                    )));
                    return function(t) {
                        return n.apply(this, arguments)
                    }
                }())
            }
            ))
        }
          , nn = function() {
            var t = Object(u["a"])(p.a.mark((function t() {
                var e;
                return p.a.wrap((function(t) {
                    while (1)
                        switch (t.prev = t.next) {
                        case 0:
                            e = Object(Je["a"])(Ye),
                            Object(Je["b"])(e, {
                                vapidKey: "BI6O1A1hoeMXc-Gq_OfJZHloB12K-an9ot40gRasDMQh7f3rMHrSzYCXvOLyS5NMDB0kdX5l9FCNxuv6P11vDKY"
                            }).then((function(t) {
                                t && (console.log(t),
                                $t(t))
                            }
                            )).catch((function(t) {
                                console.log("[Notification] An error occurred while releasing token. ", t)
                            }
                            ));
                        case 2:
                        case "end":
                            return t.stop()
                        }
                }
                ), t)
            }
            )));
            return function() {
                return t.apply(this, arguments)
            }
        }()
          , an = {
            name: "TheNavbar",
            components: {
                IdentityBar: Pe,
                AlarmPopupNotifications: He
            },
            directives: {
                clickOutside: {
                    bind: function(t, e, n) {
                        t.clickOutsideEvent = function(a) {
                            t === a.target || t.contains(a.target) || n.context[e.expression](a)
                        }
                        ,
                        document.body.addEventListener("click", t.clickOutsideEvent)
                    },
                    unbind: function(t) {
                        document.body.removeEventListener("click", t.clickOutsideEvent)
                    }
                }
            },
            data: function() {
                return {
                    isMobileMenuActive: !1,
                    notifications: [],
                    isUnreadNotificationExist: !1,
                    isHome: !0,
                    isAlramShow: !1,
                    isMobileAlarmShow: !1
                }
            },
            computed: Object(U["a"])(Object(U["a"])(Object(U["a"])({}, Object(M["d"])(["boardList", "boardGroups"])), Object(M["c"])(["userNickname", "userPicture"])), {}, {
                boardListVisible: function() {
                    return this.boardList.filter((function(t) {
                        return !t.is_hidden
                    }
                    ))
                },
                groupedBoardList: function() {
                    return Ve.a.groupBy(this.boardList, "group_id")
                },
                showedNotifications: function() {
                    return this.notifications.slice(0, 4)
                }
            }),
            watch: {
                $route: function() {
                    this.isMobileMenuActive = !1,
                    this.isHome = "home" === this.$route.name
                }
            },
            mounted: function() {
                en(this)
            },
            beforeMount: function() {
                var t = this;
                return Object(u["a"])(p.a.mark((function e() {
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return t.isHome = "home" === t.$route.name,
                                e.next = 3,
                                t.reloadNotification();
                            case 3:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            methods: Object(U["a"])(Object(U["a"])({
                toggleMobileMenu: function() {
                    this.isMobileMenuActive = !this.isMobileMenuActive,
                    this.isMobileAlarmShow = !1
                },
                changeLocale: _
            }, Object(M["b"])(["toggleDarkMode"])), {}, {
                click: function(t) {
                    var e = this.boardGroups.filter((function(e) {
                        return e.slug === t
                    }
                    ))[0];
                    e.clicked || this.boardGroups.forEach((function(t) {
                        t.clicked = !1
                    }
                    )),
                    e.clicked = !e.clicked
                },
                toggleAlram: function() {
                    this.isAlramShow = !this.isAlramShow
                },
                toggleMobileAlram: function() {
                    this.isMobileAlarmShow = !this.isMobileAlarmShow,
                    this.isMobileMenuActive = !1
                },
                closeAlram: function() {
                    this.isAlramShow = !1
                },
                closeMobileAlram: function() {
                    this.isMobileAlarmShow = !1
                },
                reloadNotification: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        var n, a, i, o;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return n = Object(U["a"])(Object(U["a"])({}, t.$route.query), {}, {
                                        page: "1"
                                    }),
                                    e.next = 3,
                                    De([Nt({
                                        query: n
                                    })], "notifications-failed-fetch");
                                case 3:
                                    a = e.sent,
                                    i = Object(V["a"])(a, 1),
                                    o = i[0],
                                    t.notifications = o.results,
                                    t.notifications.some((function(t) {
                                        return !t.is_read
                                    }
                                    )) && (t.isUnreadNotificationExist = !0);
                                case 8:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                }
            })
        }
          , on = an
          , sn = (n("2db6"),
        n("22f8"))
          , rn = Object(y["a"])(on, Ae, Oe, !1, null, "4ecbcb66", null);
        "function" === typeof sn["default"] && Object(sn["default"])(rn);
        var cn = rn.exports
          , ln = {
            name: "TheLayout",
            components: {
                TheAlertDialogs: xe,
                TheNavbar: cn
            },
            props: {
                isColumnLayout: {
                    type: Boolean,
                    default: !0
                }
            }
        }
          , un = ln
          , dn = (n("d532"),
        Object(y["a"])(un, le, ue, !1, null, "0144c769", null))
          , pn = dn.exports
          , mn = {
            name: "Terms",
            components: {
                TermsPopup: w,
                TheLayout: pn
            },
            beforeRouteEnter: function(t, e, n) {
                var a, i;
                null !== (a = Xt.state.auth) && void 0 !== a && null !== (i = a.userProfile) && void 0 !== i && i.agree_terms_of_service_at ? n("/") : n()
            }
        }
          , fn = mn
          , hn = Object(y["a"])(fn, re, ce, !1, null, null, null)
          , _n = hn.exports
          , bn = function() {
            var t = Object(u["a"])(p.a.mark((function t(e, n, a) {
                var i;
                return p.a.wrap((function(t) {
                    while (1)
                        switch (t.prev = t.next) {
                        case 0:
                            return t.next = 2,
                            Xt.dispatch("fetchMe");
                        case 2:
                            if (Xt.getters.isLoggedIn) {
                                t.next = 7;
                                break
                            }
                            i = e.path && "/" !== e.path ? "?next=".concat(location.protocol, "//").concat(location.host).concat(e.fullPath) : "?next=".concat(location.protocol, "//").concat(location.host, "/"),
                            a("/login".concat(i)),
                            t.next = 22;
                            break;
                        case 7:
                            return t.prev = 7,
                            t.next = 10,
                            Xt.dispatch("fetchBoardList");
                        case 10:
                            tn(),
                            a(),
                            t.next = 22;
                            break;
                        case 14:
                            if (t.prev = 14,
                            t.t0 = t["catch"](7),
                            !t.t0.apierr) {
                                t.next = 21;
                                break
                            }
                            return t.next = 19,
                            Xt.dispatch("dialog/toast", {
                                type: "error",
                                text: t.t0.apierr
                            });
                        case 19:
                            t.next = 21;
                            break;
                        case 21:
                            a();
                        case 22:
                        case "end":
                            return t.stop()
                        }
                }
                ), t, null, [[7, 14]])
            }
            )));
            return function(e, n, a) {
                return t.apply(this, arguments)
            }
        }()
          , vn = [{
            path: "/login",
            name: "facade",
            component: se,
            beforeEnter: function(t, e, n) {
                Xt.getters.isLoggedIn ? n("/") : (nn(),
                n())
            }
        }, {
            path: "/login-handler",
            name: "login-handler",
            beforeEnter: function(t, e, n) {
                Xt.commit("setAuthState", !0);
                var a = location.protocol + "//" + location.host;
                n(t.query.link.substr(a.length))
            }
        }, {
            path: "/logout",
            name: "logout-handler",
            beforeEnter: function() {
                var t = Object(u["a"])(p.a.mark((function t(e, n, a) {
                    return p.a.wrap((function(t) {
                        while (1)
                            switch (t.prev = t.next) {
                            case 0:
                                if (Xt.getters.userId) {
                                    t.next = 3;
                                    break
                                }
                                return t.next = 3,
                                Xt.dispatch("fetchMe");
                            case 3:
                                if (!Xt.getters.isLoggedIn) {
                                    t.next = 12;
                                    break
                                }
                                return t.prev = 4,
                                t.next = 7,
                                qt(Xt.getters.userId);
                            case 7:
                                t.next = 11;
                                break;
                            case 9:
                                t.prev = 9,
                                t.t0 = t["catch"](4);
                            case 11:
                                Xt.commit("setAuthState", !1);
                            case 12:
                                a("/login");
                            case 13:
                            case "end":
                                return t.stop()
                            }
                    }
                    ), t, null, [[4, 9]])
                }
                )));
                function e(e, n, a) {
                    return t.apply(this, arguments)
                }
                return e
            }()
        }, {
            path: "/tos",
            name: "terms",
            component: _n,
            beforeEnter: function() {
                var t = Object(u["a"])(p.a.mark((function t(e, n, a) {
                    return p.a.wrap((function(t) {
                        while (1)
                            switch (t.prev = t.next) {
                            case 0:
                                return t.next = 2,
                                Xt.dispatch("fetchMe");
                            case 2:
                                Xt.getters.isLoggedIn ? a() : a("/login");
                            case 3:
                            case "end":
                                return t.stop()
                            }
                    }
                    ), t)
                }
                )));
                function e(e, n, a) {
                    return t.apply(this, arguments)
                }
                return e
            }()
        }]
          , gn = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("TheLayout", {
                staticClass: "board",
                scopedSlots: t._u([{
                    key: "aside-right",
                    fn: function() {
                        return [n("TheSidebar", {
                            attrs: {
                                searchable: ""
                            }
                        })]
                    },
                    proxy: !0
                }])
            }, [n("TheBoard", {
                attrs: {
                    board: t.board,
                    title: t.boardName,
                    "from-query": t.fromQuery,
                    "banner-details": t.bannerDetail,
                    "banner-image": t.bannerImage
                },
                scopedSlots: t._u([t.topic ? {
                    key: "title",
                    fn: function() {
                        return [n("span", {
                            staticClass: "board__topic"
                        }, [t._v(" " + t._s("#" + t.topic[t.$i18n.locale + "_name"]) + " ")])]
                    },
                    proxy: !0
                } : null, 14 === t.boardId ? {
                    key: "filter",
                    fn: function() {
                        return [n("div", {
                            staticClass: "dropdown is-hoverable"
                        }, [n("div", {
                            staticClass: "dropdown-trigger"
                        }, [n("button", {
                            staticClass: "button",
                            attrs: {
                                "aria-haspopup": "true",
                                "aria-controls": "dropdown-menu"
                            }
                        }, [n("span", [t._v(t._s(0 == t.selectedOrdering ? t.$t("positive-order") : t.$t("recent-order")))]), n("span", {
                            staticClass: "icon is-small"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("expand_more")])])])]), n("div", {
                            staticClass: "dropdown-menu",
                            attrs: {
                                id: "dropdown-menu",
                                role: "menu"
                            }
                        }, [n("div", {
                            staticClass: "dropdown-content"
                        }, t._l([1, 0], (function(e) {
                            return n("a", {
                                key: e,
                                staticClass: "dropdown-item",
                                on: {
                                    click: function(n) {
                                        return t.changeOrdering(e)
                                    }
                                }
                            }, [t._v(" " + t._s(0 == e ? t.$t("positive-order") : t.$t("recent-order")) + " ")])
                        }
                        )), 0)])])]
                    },
                    proxy: !0
                } : null, 14 === t.boardId ? {
                    key: "order",
                    fn: function() {
                        return [n("div", {
                            staticClass: "dropdown is-hoverable"
                        }, [n("div", {
                            staticClass: "dropdown-trigger"
                        }, [n("button", {
                            staticClass: "button",
                            attrs: {
                                "aria-haspopup": "true",
                                "aria-controls": "dropdown-menu"
                            }
                        }, [n("span", [t._v(t._s(0 == t.selectedFilter ? t.$t("answered") : 1 == t.selectedFilter ? t.$t("not-answered") : t.$t("all-post")))]), n("span", {
                            staticClass: "icon is-small"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("expand_more")])])])]), n("div", {
                            staticClass: "dropdown-menu",
                            attrs: {
                                id: "dropdown-menu",
                                role: "menu"
                            }
                        }, [n("div", {
                            staticClass: "dropdown-content"
                        }, t._l([2, 0, 1], (function(e) {
                            return n("a", {
                                key: e,
                                staticClass: "dropdown-item",
                                on: {
                                    click: function(n) {
                                        return t.changeFilter(e)
                                    }
                                }
                            }, [t._v(" " + t._s(0 == e ? t.$t("answered") : 1 == e ? t.$t("not-answered") : t.$t("all-post")) + " ")])
                        }
                        )), 0)])])]
                    },
                    proxy: !0
                } : null, {
                    key: "option",
                    fn: function() {
                        return [t.topics && t.topics.length > 0 ? [n("div", {
                            staticClass: "board__filter-menu-tags is-hidden-touch"
                        }, [n("div", {
                            staticClass: "board__filter-item-tag start-tag"
                        }, [n("p", [t._v(" " + t._s(t.$t("filter")) + " ")])]), n("div", {
                            staticClass: "board__filter-item-tag",
                            class: {
                                "board__filter-item-tag__selected": void 0 === t.$route.query.topic
                            }
                        }, [n("router-link", {
                            attrs: {
                                to: {
                                    query: Object.assign({}, t.$route.query, {
                                        topic: void 0,
                                        page: 1
                                    })
                                }
                            }
                        }, [t._v(" " + t._s(t.$t("no-filter")) + " ")])], 1), t._l(t.topics, (function(e) {
                            return n("div", {
                                key: e.id,
                                staticClass: "board__filter-item-tag",
                                class: {
                                    "board__filter-item-tag__selected": e.slug === t.$route.query.topic
                                }
                            }, [n("router-link", {
                                attrs: {
                                    to: {
                                        query: Object.assign({}, t.$route.query, {
                                            topic: e.slug,
                                            page: 1
                                        })
                                    }
                                }
                            }, [t._v(" " + t._s(e[t.$i18n.locale + "_name"]) + " ")])], 1)
                        }
                        ))], 2), n("div", {
                            staticClass: "dropdown is-hoverable is-right board__filter is-hidden-desktop"
                        }, [n("div", {
                            staticClass: "dropdown-trigger"
                        }, [n("a", {
                            staticClass: "board__filter-trigger",
                            attrs: {
                                "aria-haspopup": "true",
                                "aria-controls": "dropdown-menu"
                            }
                        }, [t._v(" " + t._s(t.$t("filter")) + " "), n("i", {
                            staticClass: "icon material-icons"
                        }, [t._v("filter_alt")])])]), n("div", {
                            staticClass: "dropdown-menu board__filter-menu"
                        }, [n("div", {
                            staticClass: "dropdown-content"
                        }, [n("div", {
                            staticClass: "dropdown-item board__filter-item"
                        }, [n("router-link", {
                            attrs: {
                                to: {
                                    query: Object.assign({}, t.$route.query, {
                                        topic: void 0,
                                        page: 1
                                    })
                                }
                            }
                        }, [t._v(" " + t._s(t.$t("no-filter")) + " ")])], 1), t._l(t.topics, (function(e) {
                            return n("div", {
                                key: e.id,
                                staticClass: "dropdown-item board__filter-item"
                            }, [n("router-link", {
                                attrs: {
                                    to: {
                                        query: Object.assign({}, t.$route.query, {
                                            topic: e.slug,
                                            page: 1
                                        })
                                    }
                                }
                            }, [t._v(" " + t._s(e[t.$i18n.locale + "_name"]) + " ")])], 1)
                        }
                        ))], 2)])])] : t._e(), t.$route.params.boardSlug ? t._e() : [n("div", {
                            staticClass: "exclude"
                        }, [n("span", {
                            staticClass: "exclude__text"
                        }, [t._v(t._s(t.$t("exclude_portal")))]), n("a", {
                            staticClass: "exclude__change",
                            on: {
                                click: t.changePortalFilter
                            }
                        }, [n("span", {
                            staticClass: "icon is-flex-touch exclude__toggle"
                        }, ["exclude" === t.$route.query.portal ? n("i", {
                            staticClass: "material-icons exclude__icon exclude__icon--on"
                        }, [t._v("toggle_on")]) : n("i", {
                            staticClass: "material-icons exclude__icon"
                        }, [t._v("toggle_off")])])])])]]
                    },
                    proxy: !0
                }], null, !0)
            })], 1)
        }
          , yn = []
          , kn = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "board"
            }, [t.isBanner ? n("Banner", {
                attrs: {
                    "banner-name": t.title,
                    "banner-details": t.bannerDetails,
                    "banner-image": t.bannerImage
                }
            }) : t._e(), n("div", {
                staticClass: "board__header"
            }, [t.simplify ? t._e() : n("h1", {
                staticClass: "board__name"
            }, [t._v(" " + t._s(t.queryTitle) + " "), t._t("title")], 2), n("div", {
                staticClass: "board__options"
            }, [t._t("option"), t._t("filter"), t._t("order"), t.simplify ? t._e() : n("SearchBar", {
                staticClass: "board__tablet-search is-flex-touch is-hidden-mobile",
                attrs: {
                    searchable: ""
                }
            })], 2)]), t.title && !t.simplify ? n("hr", {
                staticClass: "board__divider"
            }) : t._e(), n("TheBoardTable", {
                attrs: {
                    posts: t.board.results,
                    "from-query": t.fromQueryWithPage
                }
            }), n("div", {
                staticClass: "board__navbar"
            }, [n("ThePaginator", {
                attrs: {
                    "num-pages": t.board.num_pages,
                    "current-page": t.board.current
                }
            })], 1), n("SearchBar", {
                staticClass: "board__mobile-search",
                class: t.simplify ? "is-hidden-desktop" : "is-hidden-tablet",
                attrs: {
                    searchable: "",
                    fullwidth: ""
                }
            })], 1)
        }
          , Cn = []
          , wn = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "searchbar field",
                class: {
                    "searchbar--small": t.small,
                    "searchbar--fullwidth": t.fullwidth,
                    "searchbar--long": t.long
                }
            }, [n("form", {
                staticClass: "control has-icons-right",
                on: {
                    submit: function(e) {
                        return e.preventDefault(),
                        t.search.apply(null, arguments)
                    }
                }
            }, [n("input", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.searchText,
                    expression: "searchText"
                }],
                staticClass: "input is-medium",
                attrs: {
                    name: "query",
                    type: "text"
                },
                domProps: {
                    value: t.searchText
                },
                on: {
                    input: function(e) {
                        e.target.composing || (t.searchText = e.target.value)
                    }
                }
            }), t._m(0)])])
        }
          , xn = [function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("button", {
                staticClass: "icon is-small is-right",
                attrs: {
                    type: "submit"
                }
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("search")])])
        }
        ]
          , An = {
            name: "SearchBar",
            props: {
                searchable: Boolean,
                small: Boolean,
                fullwidth: Boolean,
                long: Boolean
            },
            data: function() {
                return {
                    searchText: ""
                }
            },
            methods: {
                search: function() {
                    this.searchable ? this.$router.push({
                        query: Object(U["a"])(Object(U["a"])({}, this.$route.query), {}, {
                            query: this.searchText,
                            page: void 0
                        })
                    }) : this.$router.push({
                        name: "board",
                        query: {
                            query: this.searchText
                        }
                    })
                }
            }
        }
          , On = An
          , Sn = (n("268f"),
        Object(y["a"])(On, wn, xn, !1, null, "6f84f1c7", null))
          , $n = Sn.exports
          , jn = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "pages"
            }, [1 !== t.pageRangeMin ? n("router-link", {
                attrs: {
                    to: t.routeTo(t.pageRangeMin - 1)
                }
            }, [n("span", {
                staticClass: "icon"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("navigate_before")])])]) : t._e(), t._l(t.pageRange, (function(e) {
                return n("router-link", {
                    key: e,
                    staticClass: "page",
                    class: {
                        "is-active": e === t.currentPage
                    },
                    attrs: {
                        to: t.routeTo(e)
                    }
                }, [t._v(" " + t._s(e) + " ")])
            }
            )), t.numPages > t.pageRangeMin + 9 ? n("router-link", {
                attrs: {
                    to: t.routeTo(t.pageRangeMin + 10)
                }
            }, [n("span", {
                staticClass: "icon"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("navigate_next")])])]) : t._e()], 2)
        }
          , Tn = []
          , En = (n("a9e3"),
        {
            name: "ThePaginator",
            props: {
                numPages: Number,
                currentPage: Number
            },
            computed: {
                pageRangeMin: function() {
                    return 10 * Math.floor((this.currentPage - 1) / 10) + 1
                },
                pageRangeMax: function() {
                    return Math.min(this.pageRangeMin + 9, this.numPages)
                },
                pageRange: function() {
                    return at(this.pageRangeMin, this.pageRangeMax)
                }
            },
            methods: {
                paginatedQuery: function(t) {
                    return Object(U["a"])(Object(U["a"])({}, this.$route.query), {}, {
                        page: t
                    })
                },
                routeTo: function(t) {
                    return {
                        query: this.paginatedQuery(t)
                    }
                }
            }
        })
          , In = En
          , Pn = (n("5857"),
        Object(y["a"])(In, jn, Tn, !1, null, "dffc3784", null))
          , Nn = Pn.exports
          , Rn = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "board-table"
            }, t._l(t.posts, (function(e) {
                return n("div", {
                    key: e.id
                }, [n("BoardItem", {
                    key: e.id,
                    attrs: {
                        post: e,
                        "from-query": t.fromQuery
                    }
                }), n("hr", {
                    staticStyle: {
                        margin: "0"
                    }
                })], 1)
            }
            )), 0)
        }
          , Bn = []
          , Ln = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("router-link", {
                staticClass: "board-item",
                class: {
                    "board-item--current": t.current
                },
                attrs: {
                    to: {
                        name: "post",
                        params: {
                            postId: t.post.id
                        },
                        query: t.fromQuery
                    }
                }
            }, [n("div", {
                staticClass: "board-item__body"
            }, [n("div", {
                staticClass: "board-item__image-wrapper"
            }, [t.isSchoolBoard ? n("div", {
                staticClass: "board-item__thumbsup"
            }, [n("span", [t._v("+ " + t._s(t.thumbsUp))])]) : t.post.is_hidden ? n("div", {
                staticClass: "board-item__hidden-frame"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v(t._s(t.hidden_icon))])]) : n("img", {
                staticClass: "board-item__image",
                attrs: {
                    src: t.post.created_by.profile.picture
                }
            })]), n("div", {
                staticClass: "board-item__content"
            }, [n("div", {
                staticClass: "board-item__title-wrapper"
            }, [n("div", {
                staticClass: "board-item__title",
                class: {
                    "has-text-grey-light": t.post.is_hidden
                },
                attrs: {
                    title: t.post.title
                }
            }, [t.post.parent_topic ? n("span", {
                staticClass: "board-item__topic"
            }, [t._v(" [" + t._s(t.post.parent_topic[t.$i18n.locale + "_name"]) + "] ")]) : t._e(), t._v(" " + t._s(t.title) + " ")]), 0 !== t.post.comment_count ? n("div", {
                staticClass: "board-item__comment"
            }, [t._v(" (" + t._s(t.elideText(t.post.comment_count)) + ") ")]) : t._e(), t.hasImage ? n("i", {
                staticClass: "material-icons-outlined"
            }, [t._v(" image ")]) : t._e(), t.hasOtherAttachment ? n("i", {
                staticClass: "material-icons-outlined"
            }, [t._v(" attach_file ")]) : t._e(), t.new_update ? n("div", {
                staticClass: "board-item__read-status"
            }, [t._v(" " + t._s("N" === t.post.read_status ? "new" : "up") + " ")]) : t._e()]), n("div", {
                staticClass: "board-item__subtitle"
            }, [t.isSchoolBoard ? [n("span", [t._v(t._s(t.post.created_by.username))]), n("span", [t._v(t._s(t.timeago))]), n("div", [t._v(t._s(t.$t("views") + " " + t.elideText(t.post.hit_count)))])] : [n("span", [t._v(t._s(t.timeago))]), n("div", [t._v(t._s(t.$t("views") + " " + t.elideText(t.post.hit_count)))]), n("div", {
                staticClass: "board-item__vote"
            }, [n("div", {
                staticClass: "board-item__vote__pos"
            }, [t._v(" +" + t._s(t.post.positive_vote_count) + " ")]), n("div", {
                staticClass: "board-item__vote__neg"
            }, [t._v(" -" + t._s(t.post.negative_vote_count) + " ")])])], t.isSchoolBoard ? t._e() : n("span", {
                staticClass: "board-item__author__mobile is-hidden-tablet",
                class: {
                    "has-text-grey-light": t.post.is_hidden
                }
            }, [t._v(" " + t._s(t.post.created_by.profile.nickname) + " ")])], 2)])]), !t.isSchoolBoard && t.statusText ? n("span", {
                staticClass: "board-item__author is-hidden-mobile",
                class: {
                    "has-text-grey-light": t.post.is_hidden
                }
            }, [t._v(" " + t._s(t.post.created_by.profile.nickname) + " ")]) : n("span", {
                staticClass: "board-item__author status"
            }, [t.dday && t.isCommunicationAdmin ? n("span", {
                staticClass: "d-day"
            }, [t._v(" " + t._s(t.dday) + " ")]) : t._e(), n("div", {
                staticClass: "status--button",
                class: {
                    polling: 0 === t.status,
                    preparing: 1 === t.status,
                    answered: 2 === t.status
                }
            }, [t._v(" " + t._s(t.statusText) + " ")])])])
        }
          , Dn = [];
        n("38cf");
        function Un(t) {
            return function(e) {
                var n = e.toString();
                return n.length <= t ? n : "".concat("9".repeat(t), "+")
            }
        }
        var Mn = n("f5dc")
          , qn = a["a"].extend({
            name: "BoardItem",
            props: {
                post: {
                    type: Object,
                    required: !0
                },
                fromQuery: {
                    type: Object,
                    default: function() {
                        return {
                            from_view: "all"
                        }
                    }
                },
                current: Boolean
            },
            computed: Object(U["a"])(Object(U["a"])({}, Object(M["c"])(["isCommunicationAdmin"])), {}, {
                hasImage: function() {
                    return "IMAGE" === this.post.attachment_type || "BOTH" === this.post.attachment_type
                },
                hasOtherAttachment: function() {
                    return "NON_IMAGE" === this.post.attachment_type || "BOTH" === this.post.attachment_type
                },
                title: function() {
                    var t = this.post
                      , e = t.is_hidden
                      , n = t.why_hidden
                      , a = t.title;
                    return e ? b.t(n[0]).toString() : a
                },
                hidden_icon: function() {
                    switch (this.post.why_hidden[0]) {
                    case "ADULT_CONTENT":
                    case "SOCIAL_CONTENT":
                        return "visibility_off";
                    case "REPORTED_CONTENT":
                        return "warning";
                    case "BLOCKED_USER_CONTENT":
                        return "voice_over_off";
                    default:
                        return "help_outline"
                    }
                },
                timeago: function() {
                    return et(this.post.created_at, this.$i18n.locale)
                },
                new_update: function() {
                    var t = this.post
                      , e = t.created_at
                      , n = t.commented_at
                      , a = t.content_updated_at
                      , i = t.read_status
                      , o = [e, n, a].map((function(t) {
                        return new Date(null !== t && void 0 !== t ? t : 0).getTime()
                    }
                    ))
                      , s = Object(Mn["a"])((new Date).getTime() - Math.max.apply(Math, Object(L["a"])(o))) < 24;
                    return s && ("N" === i || "U" === i)
                },
                isSchoolBoard: function() {
                    return "/board/with-school" === this.$route.path
                },
                thumbsUp: function() {
                    return this.post.positive_vote_count
                },
                status: function() {
                    var t;
                    return null !== (t = this.post.communication_article_status) && void 0 !== t ? t : 0
                },
                statusText: function() {
                    var t = ["polling", "preparing", "answered"][this.status];
                    return this.$t("status.".concat(t)).toString()
                },
                dday: function() {
                    if (1 === this.status)
                        return 0 === this.post.days_left ? "D-Day" : this.post.days_left > 0 ? "D-".concat(this.post.days_left) : "기간 경과"
                }
            }),
            methods: {
                elideText: Un(2)
            }
        })
          , zn = qn
          , Kn = (n("4543"),
        n("f06d"))
          , Wn = Object(y["a"])(zn, Ln, Dn, !1, null, "5ad7de89", null);
        "function" === typeof Kn["default"] && Object(Kn["default"])(Wn);
        var Hn = Wn.exports
          , Fn = {
            name: "TheBoardTable",
            components: {
                BoardItem: Hn
            },
            props: {
                posts: Array,
                fromQuery: Object
            }
        }
          , Vn = Fn
          , Qn = (n("7435"),
        Object(y["a"])(Vn, Rn, Bn, !1, null, null, null))
          , Jn = Qn.exports
          , Gn = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "banner",
                style: {
                    "background-image": "url(" + t.bannerImage + ")"
                }
            }, [n("div", {
                domProps: {
                    innerHTML: t._s(t.customHtml)
                }
            }), t.customHtml ? t._e() : n("div", {
                staticClass: "banner__simple"
            }, [n("h1", {
                staticClass: "banner__name"
            }, [t._v(" " + t._s(t.bannerName) + " ")]), n("p", {
                staticClass: "banner__detail"
            }, [t._v(" " + t._s(t.bannerDetails) + " ")])])])
        }
          , Yn = []
          , Zn = {
            name: "Banner",
            props: {
                bannerName: {
                    type: String
                },
                bannerDetails: {
                    type: String
                },
                customHtml: {
                    type: String
                },
                bannerImage: String
            }
        }
          , Xn = Zn
          , ta = (n("a46c"),
        n("3cc7"))
          , ea = Object(y["a"])(Xn, Gn, Yn, !1, null, "27c701ee", null);
        "function" === typeof ta["default"] && Object(ta["default"])(ea);
        var na = ea.exports
          , aa = {
            name: "TheBoard",
            components: {
                SearchBar: $n,
                ThePaginator: Nn,
                TheBoardTable: Jn,
                Banner: na
            },
            props: {
                board: {
                    type: Object,
                    required: !0
                },
                title: String,
                bannerDetails: String,
                bannerImage: String,
                fromQuery: Object,
                simplify: Boolean
            },
            computed: {
                fromQueryWithPage: function() {
                    var t = Object(U["a"])({}, this.fromQuery);
                    return this.$route.query.query && (t.search_query = this.$route.query.query),
                    this.$route.query.page && (t.current = this.$route.query.page),
                    t
                },
                queryTitle: function() {
                    return this.$route.query.query ? this.$t("search", {
                        title: this.title,
                        query: this.$route.query.query
                    }) : this.title
                },
                isBanner: function() {
                    return "my-info" !== this.$route.name
                }
            }
        }
          , ia = aa
          , oa = (n("aa3d"),
        n("bf7b"))
          , sa = Object(y["a"])(ia, kn, Cn, !1, null, "58b54d8b", null);
        "function" === typeof oa["default"] && Object(oa["default"])(sa);
        var ra = sa.exports
          , ca = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("aside", {
                staticClass: "sidebar column is-hidden-touch"
            }, [n("SearchBar", {
                staticClass: "sidebar__search",
                attrs: {
                    searchable: t.searchable
                }
            }), n("SmallBoard", {
                attrs: {
                    listitems: t.recentPosts,
                    "from-query": {
                        from_view: "recent"
                    },
                    href: {
                        name: "my-info",
                        query: {
                            board: "recent"
                        }
                    },
                    sidebar: ""
                }
            }, [t._v(" " + t._s(t.$t("recent")) + " ")]), n("SmallBoard", {
                attrs: {
                    listitems: t.archiveList,
                    "from-query": {
                        from_view: "scrap"
                    },
                    href: {
                        name: "my-info",
                        query: {
                            board: "archive"
                        }
                    },
                    sidebar: ""
                }
            }, [t._v(" " + t._s(t.$t("archive")) + " ")])], 1)
        }
          , la = []
          , ua = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "board",
                class: {
                    "board--sidebar": t.sidebar
                }
            }, [n("div", {
                staticClass: "red-box"
            }), n("h2", {
                staticClass: "board__name"
            }, [n("span", [t._t("default")], 2), t.href ? n("router-link", {
                staticClass: "board__more",
                attrs: {
                    to: t.href
                }
            }, [n("span", {
                staticClass: "more-text"
            }, [t._v(t._s(t.$t("more")))]), n("i", {
                staticClass: "material-icons chevron_right"
            }, [t._v(" chevron_right ")])]) : t._e()], 1), t._l(t.listitems, (function(e) {
                return n("div", {
                    key: e.id,
                    staticClass: "board__post post"
                }, [n("h3", {
                    staticClass: "post__title-wrapper",
                    class: e.is_hidden ? "has-text-grey-light" : ""
                }, [n("router-link", {
                    staticClass: "post__title",
                    attrs: {
                        title: e.title,
                        to: {
                            name: "post",
                            params: {
                                postId: e.id
                            },
                            query: t.fromQuery
                        }
                    }
                }, [t._v(" " + t._s(t.title(e)) + " ")])], 1), n("div", {
                    staticClass: "post__username",
                    class: e.is_hidden ? "has-text-grey-light" : ""
                }, [t._v(" " + t._s(e.created_by.profile.nickname) + " ")])])
            }
            ))], 2)
        }
          , da = []
          , pa = {
            name: "SmallBoard",
            props: {
                listitems: {
                    type: Array,
                    required: !0
                },
                fromQuery: Object,
                detail: Boolean,
                sidebar: Boolean,
                href: Object
            },
            methods: {
                title: function(t) {
                    return t.is_hidden ? b.t(t.why_hidden[0]) : t.title
                }
            }
        }
          , ma = pa
          , fa = (n("121f"),
        n("0fdb"))
          , ha = Object(y["a"])(ma, ua, da, !1, null, "dfe1f994", null);
        "function" === typeof fa["default"] && Object(fa["default"])(ha);
        var _a = ha.exports
          , ba = {
            name: "TheSidebar",
            components: {
                SearchBar: $n,
                SmallBoard: _a
            },
            props: {
                searchable: Boolean
            },
            data: function() {
                return {
                    recent: [],
                    archives: null
                }
            },
            computed: Object(U["a"])({
                archiveList: function() {
                    return this.archivedPosts.slice(0, 5)
                },
                recentList: function() {
                    return this.recentPosts.slice(0, 5)
                }
            }, Object(M["d"])(["recentPosts", "archivedPosts"])),
            mounted: function() {
                var t = this;
                return Object(u["a"])(p.a.mark((function e() {
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return e.next = 2,
                                t.$store.dispatch("fetchRecentPosts");
                            case 2:
                                return e.next = 4,
                                t.$store.dispatch("fetchArchivedPosts");
                            case 4:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            }
        }
          , va = ba
          , ga = (n("3146"),
        n("2d24"))
          , ya = Object(y["a"])(va, ca, la, !1, null, "c1e9cc20", null);
        "function" === typeof ga["default"] && Object(ga["default"])(ya);
        var ka = ya.exports
          , Ca = {
            name: "Board",
            components: {
                TheBoard: ra,
                TheLayout: pn,
                TheSidebar: ka
            },
            data: function() {
                return {
                    board: {},
                    boardId: null,
                    selectedOrdering: this.$route.query.ordering ? 0 : 1,
                    selectedFilter: this.$route.query.communication_article__school_response_status ? 0 : this.$route.query.communication_article__school_response_status__lt ? 1 : 2
                }
            },
            computed: {
                topicId: function() {
                    return this.$route.query.topic
                },
                topics: function() {
                    var t = this.$store.getters.getBoardById(this.boardId);
                    return t ? t.topics : []
                },
                topic: function() {
                    var t = this;
                    return this.topics.find((function(e) {
                        return e.slug === t.topicId
                    }
                    ))
                },
                boardName: function() {
                    return this.$store.getters.getNameById(this.boardId, this.$i18n.locale)
                },
                bannerDetail: function() {
                    return this.$store.getters.getBannerDescriptionById(this.boardId, this.$i18n.locale)
                },
                bannerImage: function() {
                    return this.$store.getters.getBannerImageById(this.boardId)
                },
                fromQuery: function() {
                    var t = this.board.current;
                    return "exclude" === this.$route.query.portal ? {
                        from_view: "-portal",
                        current: t
                    } : this.topicId ? {
                        from_view: "topic",
                        topic_id: this.topicId,
                        current: t
                    } : this.boardId ? {
                        from_view: "board",
                        current: t
                    } : {
                        from_view: "all",
                        current: t
                    }
                }
            },
            beforeRouteEnter: function(t, e, n) {
                return Object(u["a"])(p.a.mark((function e() {
                    var a, i, o, s, r, c, l, u, d, m;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return a = t.params.boardSlug,
                                i = t.query,
                                r = {},
                                "exclude" === i.portal ? (o = Xt.state.boardList.filter((function(t) {
                                    return "portal-notice" !== t.slug
                                }
                                )).map((function(t) {
                                    return t.id
                                }
                                )),
                                s = Xt.getters.getBoardById(null)) : (o = a ? Xt.getters.getIdBySlug(a) : null,
                                s = Xt.getters.getBoardById(o)),
                                "2" === i.communication_article__school_response_status && (r.communication_article__school_response_status = i.communication_article__school_response_status),
                                "2" === i.communication_article__school_response_status__lt && (r.communication_article__school_response_status__lt = i.communication_article__school_response_status__lt),
                                c = i.topic && s ? s.topics.find((function(t) {
                                    return t.slug === i.topic
                                }
                                )) : null,
                                l = c ? c.id : null,
                                e.next = 9,
                                De([Wt(Object(U["a"])(Object(U["a"])({
                                    boardId: o,
                                    topicId: l
                                }, i), {}, {
                                    filter: r
                                }))], "board-failed-fetch");
                            case 9:
                                u = e.sent,
                                d = Object(V["a"])(u, 1),
                                m = d[0],
                                n((function(t) {
                                    t.board = m,
                                    t.boardId = o,
                                    document.title = "Ara - ".concat(t.boardName)
                                }
                                ));
                            case 13:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            beforeRouteUpdate: function(t, e, n) {
                var a = this;
                return Object(u["a"])(p.a.mark((function e() {
                    var i, o, s, r, c, l, u, d, m;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return i = t.params.boardSlug,
                                o = t.query,
                                r = {},
                                s = "exclude" === o.portal ? Xt.state.boardList.filter((function(t) {
                                    return "portal-notice" !== t.slug
                                }
                                )).map((function(t) {
                                    return t.id
                                }
                                )) : i ? Xt.getters.getIdBySlug(i) : null,
                                "2" === o.communication_article__school_response_status && (r.communication_article__school_response_status = o.communication_article__school_response_status),
                                "2" === o.communication_article__school_response_status__lt && (r.communication_article__school_response_status__lt = o.communication_article__school_response_status__lt),
                                c = o.topic ? Xt.getters.getBoardById(a.boardId).topics.find((function(t) {
                                    return t.slug === o.topic
                                }
                                )) : null,
                                l = c ? c.id : null,
                                e.next = 9,
                                De([Wt(Object(U["a"])(Object(U["a"])({
                                    boardId: s,
                                    topicId: l
                                }, o), {}, {
                                    filter: r
                                }))], "board-failed-fetch");
                            case 9:
                                u = e.sent,
                                d = Object(V["a"])(u, 1),
                                m = d[0],
                                a.board = m,
                                a.boardId = s,
                                document.title = "Ara - ".concat(a.boardName),
                                n();
                            case 16:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            methods: {
                changePortalFilter: function() {
                    "exclude" === this.$route.query.portal ? this.$router.push({
                        query: Object(U["a"])(Object(U["a"])({}, this.$route.query), {}, {
                            portal: void 0
                        })
                    }) : this.$router.push({
                        query: Object(U["a"])(Object(U["a"])({}, this.$route.query), {}, {
                            portal: "exclude"
                        })
                    })
                },
                changeOrdering: function(t) {
                    switch (t) {
                    case 1:
                        this.selectedOrdering = 1,
                        this.$router.push({
                            query: Object(U["a"])(Object(U["a"])({}, this.$route.query), {}, {
                                ordering: "-created_at"
                            })
                        });
                        break;
                    case 0:
                        this.selectedOrdering = 0,
                        this.$router.push({
                            query: Object(U["a"])(Object(U["a"])({}, this.$route.query), {}, {
                                ordering: "-positive_vote_count, -created_at"
                            })
                        });
                        break;
                    default:
                        break
                    }
                },
                changeFilter: function(t) {
                    switch (t) {
                    case 0:
                        this.selectedFilter = 0,
                        this.$router.push({
                            query: Object(U["a"])(Object(U["a"])({}, this.$route.query), {}, {
                                communication_article__school_response_status: 2,
                                communication_article__school_response_status__lt: void 0
                            })
                        });
                        break;
                    case 1:
                        this.selectedFilter = 1,
                        this.$router.push({
                            query: Object(U["a"])(Object(U["a"])({}, this.$route.query), {}, {
                                communication_article__school_response_status: void 0,
                                communication_article__school_response_status__lt: 2
                            })
                        });
                        break;
                    default:
                        this.selectedFilter = 2,
                        this.$router.push({
                            query: Object(U["a"])(Object(U["a"])({}, this.$route.query), {}, {
                                communication_article__school_response_status: void 0,
                                communication_article__school_response_status__lt: void 0
                            })
                        });
                        break
                    }
                }
            }
        }
          , wa = Ca
          , xa = (n("1681"),
        n("fe65"))
          , Aa = Object(y["a"])(wa, gn, yn, !1, null, "23d500ca", null);
        "function" === typeof xa["default"] && Object(xa["default"])(Aa);
        var Oa = Aa.exports
          , Sa = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("TheLayout", {
                scopedSlots: t._u([{
                    key: "aside-right",
                    fn: function() {
                        return [n("TheSidebar", {
                            attrs: {
                                searchable: ""
                            }
                        })]
                    },
                    proxy: !0
                }])
            }, [n("TheBoard", {
                attrs: {
                    board: t.board,
                    title: t.user.nickname,
                    "from-query": {
                        from_view: "user",
                        created_by: t.user.user
                    }
                },
                scopedSlots: t._u([{
                    key: "title",
                    fn: function() {
                        return [n("div", {
                            staticClass: "title-description"
                        }, [t._v(" 사용자 ")])]
                    },
                    proxy: !0
                }])
            })], 1)
        }
          , $a = []
          , ja = {
            name: "User",
            components: {
                TheBoard: ra,
                TheLayout: pn,
                TheSidebar: ka
            },
            data: function() {
                return {
                    board: {},
                    user: {}
                }
            },
            beforeRouteEnter: function(t, e, n) {
                return Object(u["a"])(p.a.mark((function e() {
                    var a, i, o, s, r, c;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return a = t.params.username,
                                i = t.query,
                                e.next = 3,
                                De([Wt(Object(U["a"])({
                                    username: a
                                }, i)), jt(a)], "user-failed-fetch");
                            case 3:
                                o = e.sent,
                                s = Object(V["a"])(o, 2),
                                r = s[0],
                                c = s[1],
                                document.title = "Ara - ".concat(c.nickname),
                                n((function(t) {
                                    t.board = r,
                                    t.user = c
                                }
                                ));
                            case 9:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            beforeRouteUpdate: function(t, e, n) {
                var a = this;
                return Object(u["a"])(p.a.mark((function e() {
                    var i, o, s, r, c, l;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return i = t.params.username,
                                o = t.query,
                                e.next = 3,
                                De([Wt(Object(U["a"])({
                                    username: i
                                }, o)), jt(i)], "user-failed-fetch");
                            case 3:
                                s = e.sent,
                                r = Object(V["a"])(s, 2),
                                c = r[0],
                                l = r[1],
                                document.title = "Ara - ".concat(l.nickname),
                                a.board = c,
                                a.user = l,
                                n();
                            case 11:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            }
        }
          , Ta = ja
          , Ea = (n("e8c3"),
        Object(y["a"])(Ta, Sa, $a, !1, null, null, null))
          , Ia = Ea.exports
          , Pa = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("TheLayout", {
                key: t.postId,
                staticClass: "post",
                scopedSlots: t._u([{
                    key: "aside-right",
                    fn: function() {
                        return [n("TheSidebar")]
                    },
                    proxy: !0
                }])
            }, [n("ThePostHeader", {
                attrs: {
                    post: t.post,
                    context: t.context
                },
                on: {
                    archive: t.archive,
                    report: t.report,
                    vote: t.vote
                }
            }), n("ThePostDetail", {
                attrs: {
                    post: t.post
                },
                on: {
                    archive: t.archive,
                    block: t.block,
                    report: t.report,
                    "copy-url": t.copyURL,
                    vote: t.vote,
                    "show-hidden": t.overrideHidden
                }
            }), n("ThePostComments", {
                attrs: {
                    post: t.post,
                    comments: t.post.comments
                },
                on: {
                    upload: t.addNewComment,
                    update: t.updateComment,
                    refresh: t.refresh,
                    "fetch-comment": t.overrideHiddenComment
                }
            }), n("ThePostNavigation", {
                attrs: {
                    post: t.post,
                    context: t.context
                }
            })], 1)
        }
          , Na = []
          , Ra = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "comments",
                attrs: {
                    id: "comments"
                }
            }, [n("div", {
                staticClass: "comments__title"
            }, [t._v(" " + t._s(t.$t("comments")) + " " + t._s(t.commentCount) + " ")]), t.comments ? n("div", {
                staticClass: "comments__container"
            }, t._l(t.comments, (function(e) {
                return n("PostComment", {
                    key: e.id,
                    staticClass: "comments__comment",
                    attrs: {
                        comment: e,
                        post: t.post
                    },
                    on: {
                        update: function(e) {
                            return t.$emit("update", e)
                        },
                        upload: function(e) {
                            return t.$emit("upload", e)
                        },
                        delete: function(e) {
                            return t.$emit("refresh")
                        },
                        "fetch-comment": function(e) {
                            return t.$emit("fetch-comment", e)
                        }
                    }
                })
            }
            )), 1) : n("div", {
                staticClass: "comments__container comments__container--empty"
            }, [t._v(" " + t._s(t.$t("no-comment")) + " ")]), n("PostCommentEditor", {
                attrs: {
                    "parent-article": t.post.id,
                    post: t.post
                },
                on: {
                    upload: function(e) {
                        return t.$emit("upload", e)
                    }
                }
            })], 1)
        }
          , Ba = []
          , La = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "comment-wrapper"
            }, [t.isEditing ? n("div", {
                staticClass: "comment comment--edit",
                class: {
                    "comment--reply-comment": t.isReplyComment
                }
            }, [n("PostCommentEditor", {
                attrs: {
                    text: t.comment.content,
                    "edit-comment": t.comment.id,
                    post: t.post
                },
                on: {
                    upload: t.updateComment,
                    close: function(e) {
                        t.isEditing = !1
                    }
                }
            })], 1) : n("div", {
                staticClass: "comment",
                class: {
                    "comment--reply-comment": t.isReplyComment
                }
            }, [t.isHidden ? n("div", {
                staticClass: "comment__profile"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v(t._s(t.hidden_icon))])]) : n("img", {
                staticClass: "comment__profile",
                attrs: {
                    src: t.profileImage,
                    alt: "profile image"
                }
            }), n("div", {
                staticClass: "comment__body"
            }, [n("div", {
                staticClass: "comment__header"
            }, [n(t.isRegular ? "router-link" : "span", {
                tag: "router-link",
                staticClass: "comment__author",
                class: t.isAuthor ? "author_red" : "",
                attrs: {
                    to: {
                        name: "user",
                        params: {
                            username: t.authorId
                        }
                    }
                }
            }, [n("div", {
                staticClass: "comment__author_box"
            }, [n("div", [t._v(" " + t._s(t.author) + " ")]), t.isVerified ? n("i", {
                staticClass: "material-icons"
            }, [t._v("verified")]) : t._e()])]), n("span", {
                staticClass: "comment__time"
            }, [t._v(" " + t._s(t.date) + " ")]), t.isDeleted || t.isHidden ? t._e() : n("div", {
                staticClass: "dropdown is-right is-hoverable"
            }, [t._m(0), n("div", {
                staticClass: "dropdown-menu",
                attrs: {
                    id: "dropdownMenu",
                    role: "menu"
                }
            }, [n("div", {
                staticClass: "dropdown-content"
            }, [n("div", {
                staticClass: "dropdown-item"
            }, [t.isMine ? [n("a", {
                staticClass: "dropdown-item",
                on: {
                    click: t.editComment
                }
            }, [t._v(" " + t._s(t.$t("edit")) + " ")]), n("a", {
                staticClass: "dropdown-item",
                on: {
                    click: t.deleteComment
                }
            }, [t._v(" " + t._s(t.$t("delete")) + " ")])] : n("a", {
                staticClass: "dropdown-item",
                on: {
                    click: t.reportComment
                }
            }, [t._v(" " + t._s(t.$t("report")) + " ")])], 2)])])])], 1), n("div", {
                staticClass: "comment__content"
            }, [n("div", {
                style: t.isHidden && !t.canOveride ? "color: #aaa;" : "",
                domProps: {
                    innerHTML: t._s(t.content)
                }
            }), t.isHidden && t.canOveride ? n("div", [n("button", {
                staticClass: "button",
                on: {
                    click: function(e) {
                        return t.$emit("fetch-comment", {
                            commentId: t.comment.id
                        })
                    }
                }
            }, [t._v(" " + t._s(t.$t("show-hidden")) + " ")])]) : t._e()]), n("div", {
                staticClass: "comment__footer"
            }, [t.isHidden ? t._e() : n("LikeButton", {
                staticClass: "comment__vote",
                attrs: {
                    item: t.comment,
                    votable: "",
                    "is-mine": t.comment.is_mine
                },
                on: {
                    vote: t.vote
                }
            }), t.isReplyComment ? t._e() : n("a", {
                staticClass: "comment__write",
                on: {
                    click: t.toggleReplyCommentInput
                }
            }, [t._v(" " + t._s(t.showReplyCommentInput ? t.$t("fold-reply-comment") : t.$t("reply-comment")) + " ")])], 1)])]), n("div", {
                staticClass: "comment__reply-comments"
            }, [t._l(t.comment.comments, (function(e) {
                return n("PostComment", {
                    key: e.id,
                    attrs: {
                        comment: e,
                        post: t.post,
                        "is-reply-comment": ""
                    },
                    on: {
                        vote: function(e) {
                            return t.$emit("vote")
                        },
                        delete: function(e) {
                            return t.$emit("delete")
                        },
                        update: function(e) {
                            return t.$emit("update", e)
                        },
                        upload: function(e) {
                            return t.$emit("upload", e)
                        },
                        "fetch-comment": function(e) {
                            return t.$emit("fetch-comment", e)
                        }
                    }
                })
            }
            )), n("div", {
                directives: [{
                    name: "show",
                    rawName: "v-show",
                    value: t.showReplyCommentInput,
                    expression: "showReplyCommentInput"
                }]
            }, [n("PostCommentEditor", {
                ref: "commentEditor",
                attrs: {
                    post: t.post,
                    "parent-comment": t.comment.id
                },
                on: {
                    upload: function(e) {
                        return t.$emit("upload", e)
                    },
                    close: function(e) {
                        t.showReplyCommentInput = !1
                    }
                }
            })], 1)], 2)])
        }
          , Da = [function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "dropdown-trigger"
            }, [n("button", {
                staticClass: "dropdown-button",
                attrs: {
                    "aria-haspopup": "true",
                    "aria-controls": "dropdownMenu"
                }
            }, [n("span", {
                staticClass: "icon"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("more_vert")])])])])
        }
        ]
          , Ua = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "like-button",
                class: {
                    "like-button--enabled": t.votable,
                    "like-button--table": t.table
                }
            }, [n("button", {
                staticClass: "like-button__item",
                class: {
                    "like-button__item--like-selected": t.liked
                },
                on: {
                    click: function(e) {
                        return t.vote(!0)
                    }
                }
            }, [t.liked ? n("i", {
                staticClass: "like-button__icon material-icons"
            }, [t._v("thumb_up")]) : n("i", {
                staticClass: "like-button__icon material-icons-outlined"
            }, [t._v("thumb_up")]), t._v(" " + t._s(t.likedCount) + " ")]), n("button", {
                staticClass: "like-button__item",
                class: {
                    "like-button__item--dislike-selected": t.disliked
                },
                on: {
                    click: function(e) {
                        return t.vote(!1)
                    }
                }
            }, [t.disliked ? n("i", {
                staticClass: "like-button__icon material-icons"
            }, [t._v("thumb_down")]) : n("i", {
                staticClass: "like-button__icon material-icons-outlined"
            }, [t._v("thumb_down")]), t._v(" " + t._s(t.dislikedCount) + " ")])])
        }
          , Ma = []
          , qa = (n("caad"),
        Un(3))
          , za = {
            name: "LikeButton",
            props: {
                item: {
                    type: Object,
                    required: !0
                },
                votable: Boolean,
                elide: Boolean,
                table: Boolean,
                isMine: Boolean
            },
            computed: {
                liked: function() {
                    return !0 === this.item.my_vote
                },
                disliked: function() {
                    return !1 === this.item.my_vote
                },
                likedCount: function() {
                    return this.elideText(this.item.positive_vote_count)
                },
                dislikedCount: function() {
                    return this.elideText(this.item.negative_vote_count)
                }
            },
            methods: {
                vote: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a, i, o;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    if (e.votable) {
                                        n.next = 2;
                                        break
                                    }
                                    return n.abrupt("return");
                                case 2:
                                    if (!e.isMine) {
                                        n.next = 5;
                                        break
                                    }
                                    return e.$store.dispatch("dialog/toast", e.$t("nonvotable-myself")),
                                    n.abrupt("return");
                                case 5:
                                    if (!e.liked || ![1, 2].includes(e.item.communication_article_status)) {
                                        n.next = 8;
                                        break
                                    }
                                    return e.$store.dispatch("dialog/toast", e.$t("impossible-cancel-like")),
                                    n.abrupt("return");
                                case 8:
                                    a = e.item.my_vote,
                                    i = t,
                                    !0 === i && !0 !== a ? e.item.positive_vote_count++ : !0 === a && e.item.positive_vote_count--,
                                    !1 === i && !1 !== a ? e.item.negative_vote_count++ : !1 === a && e.item.negative_vote_count--,
                                    e.item.my_vote = a === i ? null : i,
                                    o = a === i ? "vote_cancel" : i ? "vote_positive" : "vote_negative",
                                    e.$emit("vote", {
                                        id: e.item.id,
                                        vote: o
                                    });
                                case 15:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n)
                    }
                    )))()
                },
                elideText: function(t) {
                    return this.elide ? qa(t) : t
                }
            }
        }
          , Ka = za
          , Wa = (n("4b62"),
        n("9eb0"))
          , Ha = Object(y["a"])(Ka, Ua, Ma, !1, null, "224bb8fc", null);
        "function" === typeof Wa["default"] && Object(Wa["default"])(Ha);
        var Fa = Ha.exports
          , Va = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "comment-editor"
            }, [n("label", {
                staticClass: "textarea comment-editor__input"
            }, [n("div", {
                staticClass: "comment-editor__author"
            }, [n("img", {
                staticClass: "comment-editor__picture",
                attrs: {
                    src: t.userPicture
                }
            }), n("span", {
                staticClass: "comment-editor__name",
                class: t.authorRed
            }, [t._v(t._s(t.userNickname))]), t.isVerified ? n("i", {
                staticClass: "material-icons"
            }, [t._v("verified")]) : t._e()]), n("div", {
                staticClass: "comment-editor__content"
            }, [n("textarea", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.content,
                    expression: "content"
                }],
                ref: "input",
                staticClass: "comment-editor__editor",
                style: {
                    height: t.height
                },
                attrs: {
                    placeholder: t.$t("placeholder"),
                    rows: "1"
                },
                domProps: {
                    value: t.content
                },
                on: {
                    keydown: function(e) {
                        return !e.type.indexOf("key") && t._k(e.keyCode, "enter", 13, e.key, "Enter") ? null : e.shiftKey ? (e.preventDefault(),
                        t.saveComment.apply(null, arguments)) : null
                    },
                    input: [function(e) {
                        e.target.composing || (t.content = e.target.value)
                    }
                    , t.autosize]
                }
            })])]), n("div", {
                staticClass: "comment-editor__buttons"
            }, [t.editComment || t.parentComment ? n("button", {
                staticClass: "button comment-editor__submit",
                class: {
                    "is-loading": t.isUploading
                },
                attrs: {
                    disabled: t.isUploading
                },
                on: {
                    click: t.closeComment
                }
            }, [t._v(" " + t._s(t.$t("close-comment")) + " ")]) : t._e(), n("button", {
                staticClass: "button comment-editor__submit",
                class: {
                    "is-loading": t.isUploading
                },
                attrs: {
                    disabled: t.isUploading
                },
                on: {
                    click: t.saveComment
                }
            }, [t._v(" " + t._s(t.$t("new-comment")) + " ")])])])
        }
          , Qa = []
          , Ja = {
            name: "PostCommentEditor",
            props: {
                post: {
                    type: Object,
                    required: !0
                },
                text: {
                    type: String,
                    default: ""
                },
                parentArticle: Number,
                parentComment: Number,
                editComment: Number
            },
            data: function() {
                return {
                    content: this.text,
                    height: "auto",
                    isUploading: !1
                }
            },
            computed: {
                userNickname: function() {
                    return this.post.my_comment_profile ? this.post.my_comment_profile.profile.nickname : this.$t("placeholder")
                },
                userPicture: function() {
                    var t;
                    return this.post.my_comment_profile ? this.post.my_comment_profile.profile.picture : null === (t = this.post.created_by) || void 0 === t ? void 0 : t.profile.picture
                },
                authorRed: function() {
                    return 1 !== this.post.name_type && this.post.is_mine ? "author_red" : ""
                },
                isVerified: function() {
                    if (!this.post.my_comment_profile || !this.post.parent_board)
                        return !1;
                    var t = this.post.my_comment_profile.profile;
                    return 14 === this.post.parent_board.id ? t.is_school_admin : t.is_official
                }
            },
            methods: {
                autosize: function() {
                    var t = this;
                    this.height = "auto",
                    this.$nextTick((function() {
                        if (t.$refs.input) {
                            var e = t.$refs.input.scrollHeight;
                            t.height = "".concat(e, "px")
                        }
                    }
                    ))
                },
                saveComment: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        var n;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    if (!t.isUploading) {
                                        e.next = 2;
                                        break
                                    }
                                    return e.abrupt("return");
                                case 2:
                                    if (t.content) {
                                        e.next = 5;
                                        break
                                    }
                                    return t.$store.dispatch("dialog/toast", {
                                        type: "warning",
                                        text: t.$t("no-empty")
                                    }),
                                    e.abrupt("return");
                                case 5:
                                    if (t.isUploading = !0,
                                    e.prev = 6,
                                    !t.editComment) {
                                        e.next = 13;
                                        break
                                    }
                                    return e.next = 10,
                                    kt(t.editComment, {
                                        content: t.content,
                                        name_type: t.post.name_type,
                                        is_mine: !0
                                    });
                                case 10:
                                    e.t0 = e.sent,
                                    e.next = 16;
                                    break;
                                case 13:
                                    return e.next = 15,
                                    yt({
                                        parent_article: t.parentArticle,
                                        parent_comment: t.parentComment,
                                        content: t.content,
                                        name_type: t.post.name_type
                                    });
                                case 15:
                                    e.t0 = e.sent;
                                case 16:
                                    n = e.t0,
                                    t.$emit("upload", n),
                                    t.content = "",
                                    t.autosize(),
                                    e.next = 25;
                                    break;
                                case 22:
                                    e.prev = 22,
                                    e.t1 = e["catch"](6),
                                    t.$store.dispatch("dialog/toast", {
                                        text: t.$t("write-failed") + (e.t1.apierr ? "\n" + e.t1.apierr : ""),
                                        type: "error"
                                    });
                                case 25:
                                    t.isUploading = !1;
                                case 26:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e, null, [[6, 22]])
                    }
                    )))()
                },
                closeComment: function() {
                    this.$emit("close")
                },
                focus: function() {
                    this.$refs.input.focus()
                }
            }
        }
          , Ga = Ja
          , Ya = (n("0d2e"),
        n("4079"))
          , Za = Object(y["a"])(Ga, Va, Qa, !1, null, "2bde7b8c", null);
        "function" === typeof Ya["default"] && Object(Ya["default"])(Za);
        var Xa = Za.exports
          , ti = {
            name: "PostComment",
            components: {
                LikeButton: Fa,
                PostCommentEditor: Xa
            },
            props: {
                post: {
                    type: Object,
                    required: !0
                },
                comment: {
                    type: Object,
                    required: !0
                },
                isReplyComment: Boolean
            },
            data: function() {
                return {
                    isEditing: !1,
                    isVoting: !1,
                    showReplyCommentInput: !1
                }
            },
            computed: Object(U["a"])(Object(U["a"])({
                author: function() {
                    var t;
                    return null === (t = this.comment.created_by) || void 0 === t ? void 0 : t.profile.nickname
                },
                authorId: function() {
                    return this.comment.created_by.id
                },
                profileImage: function() {
                    var t, e;
                    return null === (t = this.comment.created_by) || void 0 === t || null === (e = t.profile) || void 0 === e ? void 0 : e.picture
                },
                date: function() {
                    return et(this.comment.created_at, this.$i18n.locale)
                }
            }, Object(M["c"])(["userNickname", "isCommunicationAdmin", "userPicture"])), {}, {
                content: function() {
                    return this.comment.is_hidden ? this.$t(this.comment.why_hidden[0]) : this.comment.content
                },
                canOveride: function() {
                    return this.comment.can_override_hidden
                },
                isMine: function() {
                    return this.comment.is_mine
                },
                isRegular: function() {
                    return 1 === this.comment.name_type
                },
                isVerified: function() {
                    if (!this.comment.created_by || !this.post.parent_board)
                        return !1;
                    var t = this.comment.created_by.profile;
                    return 14 === this.post.parent_board.id ? t.is_school_admin : t.is_official
                },
                isAuthor: function() {
                    return 1 !== this.comment.name_type && this.post.created_by.id === this.comment.created_by.id
                },
                isDeleted: function() {
                    return this.comment.is_hidden && "DELETED_CONTENT" === this.comment.why_hidden[0]
                },
                isHidden: function() {
                    return this.comment.is_hidden
                },
                hidden_icon: function() {
                    switch (this.comment.why_hidden[0]) {
                    case "REPORTED_CONTENT":
                        return "warning";
                    case "BLOCKED_USER_CONTENT":
                        return "voice_over_off";
                    case "DELETED_CONTENT":
                        return "delete";
                    default:
                        return "help_outline"
                    }
                }
            }),
            methods: {
                vote: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    if (!e.isMine) {
                                        n.next = 6;
                                        break
                                    }
                                    return n.next = 3,
                                    e.$store.dispatch("dialog/toast", e.$t("nonvotable-myself"));
                                case 3:
                                    if (a = n.sent,
                                    a) {
                                        n.next = 6;
                                        break
                                    }
                                    return n.abrupt("return");
                                case 6:
                                    return e.isVoting = !0,
                                    n.next = 9,
                                    Ct(t.id, t.vote);
                                case 9:
                                    e.isVoting = !1;
                                case 10:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n)
                    }
                    )))()
                },
                toggleReplyCommentInput: function() {
                    var t = this;
                    this.showReplyCommentInput = !this.showReplyCommentInput,
                    this.$nextTick((function() {
                        t.$refs.commentEditor.focus()
                    }
                    ))
                },
                deleteComment: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        var n;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return e.next = 2,
                                    t.$store.dispatch("dialog/confirm", t.$t("confirm-delete"));
                                case 2:
                                    if (n = e.sent,
                                    n) {
                                        e.next = 5;
                                        break
                                    }
                                    return e.abrupt("return");
                                case 5:
                                    return e.next = 7,
                                    xt(t.comment.id);
                                case 7:
                                    t.$emit("delete");
                                case 8:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                reportComment: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        var n, a, i, o, s, r;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return e.next = 2,
                                    t.$store.dispatch("dialog/report", t.$t("confirm-report"));
                                case 2:
                                    if (n = e.sent,
                                    a = n.result,
                                    i = n.selection,
                                    a) {
                                        e.next = 7;
                                        break
                                    }
                                    return e.abrupt("return");
                                case 7:
                                    for (r in o = "others",
                                    s = "",
                                    i)
                                        i[r] && (s += r,
                                        s += ", ");
                                    return s = s.slice(0, -2),
                                    e.next = 13,
                                    wt(t.comment.id, o, s);
                                case 13:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                editComment: function() {
                    this.isEditing = !0
                },
                updateComment: function(t) {
                    this.isEditing = !1,
                    this.$emit("update", Object(U["a"])(Object(U["a"])({}, t), {}, {
                        is_mine: !0
                    }))
                }
            }
        }
          , ei = ti
          , ni = (n("d29e"),
        n("ac24"))
          , ai = Object(y["a"])(ei, La, Da, !1, null, "30ce9824", null);
        "function" === typeof ni["default"] && Object(ni["default"])(ai);
        var ii = ai.exports
          , oi = {
            name: "ThePostComments",
            components: {
                PostComment: ii,
                PostCommentEditor: Xa
            },
            props: {
                post: {
                    type: Object,
                    required: !0
                },
                comments: Array
            },
            computed: {
                commentCount: function() {
                    return this.post && this.comments ? this.post.comment_count : 0
                }
            }
        }
          , si = oi
          , ri = (n("8785"),
        n("df97"))
          , ci = Object(y["a"])(si, Ra, Ba, !1, null, "243d0758", null);
        "function" === typeof ri["default"] && Object(ri["default"])(ci);
        var li = ci.exports
          , ui = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "post"
            }, [t.attachments && t.attachments.length > 0 ? n("div", {
                staticClass: "attachments"
            }, [n("div", {
                staticClass: "dropdown is-hoverable is-right"
            }, [n("div", {
                staticClass: "dropdown-trigger"
            }, [n("a", {
                staticClass: "attachments__title",
                attrs: {
                    "aria-haspopup": "true",
                    "aria-controls": "dropdown-menu"
                }
            }, [n("span", [t._v(" " + t._s(t.$t("attachments")) + " " + t._s(t.attachments.length) + " ")])])]), n("div", {
                staticClass: "dropdown-menu"
            }, [n("div", {
                staticClass: "dropdown-content"
            }, t._l(t.attachments, (function(e) {
                var a = e.id
                  , i = e.file
                  , o = e.url;
                return n("div", {
                    key: a,
                    staticClass: "attachments__item dropdown-item"
                }, [n("div", [n("a", {
                    attrs: {
                        href: o,
                        target: "_blank",
                        rel: "noopener"
                    }
                }, [t._v(" " + t._s(i) + " ")])])])
            }
            )), 0)])])]) : t._e(), n("div", {
                staticClass: "content"
            }, [t.post.url ? n("ThePostBookmark", {
                staticClass: "content__bookmark",
                attrs: {
                    node: {
                        attrs: {
                            title: t.post.title,
                            href: t.post.url
                        }
                    }
                }
            }) : t._e(), t.content ? n("TextEditor", {
                ref: "editor",
                attrs: {
                    editable: !1,
                    content: t.content
                }
            }) : t._e(), t.post.is_hidden ? n("div", {
                staticClass: "hidden-container"
            }, [n("div", {
                staticClass: "hidden-container__frame"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v(t._s(t.hidden_icon))])]), n("div", {
                domProps: {
                    innerHTML: t._s(t.hiddenReason)
                }
            }), t.post.can_override_hidden ? n("button", {
                staticClass: "button hidden-container__button",
                on: {
                    click: function(e) {
                        return t.$emit("show-hidden")
                    }
                }
            }, [t._v(" " + t._s(t.$t("show-hidden")) + " ")]) : t._e()]) : t._e()], 1), t.post.is_hidden && 2 === t.post.name_type ? t._e() : n("div", {
                staticClass: "post__footer"
            }, [t.post.is_hidden ? t._e() : n("LikeButton", {
                staticClass: "post__like",
                attrs: {
                    item: t.post,
                    votable: "",
                    "is-mine": t.post.is_mine
                },
                on: {
                    vote: function(e) {
                        return t.$emit("vote", e)
                    }
                }
            }), n("div", {
                staticClass: "post__buttons-box",
                class: {
                    "post__buttons--hidden": t.post.is_hidden
                }
            }, [n("div", {
                staticClass: "post__buttons"
            }, [t.isMine && !1 !== t.post.can_override_hidden && !t.post.is_hidden ? [n("button", {
                staticClass: "button mobile-button",
                on: {
                    click: t.deletePost
                }
            }, [n("i", {
                staticClass: "like-button__icon material-icons-outlined"
            }, [t._v(" delete ")]), n("label", {
                staticClass: "button-text"
            }, [t._v(t._s(t.$t("delete")))])]), n("router-link", {
                staticClass: "button mobile-button",
                attrs: {
                    to: {
                        name: "write",
                        params: {
                            postId: t.postId
                        }
                    }
                }
            }, [n("i", {
                staticClass: "like-button__icon material-icons-outlined"
            }, [t._v(" edit ")]), n("label", {
                staticClass: "button-text"
            }, [t._v(t._s(t.$t("edit")))])])] : [t.isRegular ? n("button", {
                staticClass: "button mobile-button",
                on: {
                    click: function(e) {
                        return t.$emit("block")
                    }
                }
            }, [n("i", {
                staticClass: "like-button__icon material-icons-outlined"
            }, [t._v(" remove_circle_outline ")]), n("label", {
                staticClass: "button-text"
            }, [t._v(t._s(t.$t(t.isBlocked ? "unblock" : "block")))])]) : t._e(), !t.post.is_hidden && t.isNotRealName ? n("button", {
                staticClass: "button mobile-button",
                on: {
                    click: function(e) {
                        return t.$emit("report")
                    }
                }
            }, [n("i", {
                staticClass: "like-button__icon material-icons-outlined"
            }, [t._v(" campaign ")]), n("label", {
                staticClass: "button-text"
            }, [t._v(t._s(t.$t("report")))])]) : t._e()]], 2), n("div", {
                staticClass: "post__buttons"
            }, [t.post.is_hidden ? t._e() : n("button", {
                staticClass: "button",
                on: {
                    click: function(e) {
                        return t.$emit("copy-url")
                    }
                }
            }, [n("i", {
                staticClass: "like-button__icon material-icons-outlined"
            }, [t._v("content_copy")]), t._v(" " + t._s(t.$t("copy-url")) + " ")]), t.post.is_hidden ? t._e() : n("button", {
                staticClass: "button archive-button",
                class: {
                    "button--clicked": t.post.my_scrap
                },
                on: {
                    click: function(e) {
                        return t.$emit("archive")
                    }
                }
            }, [n("i", {
                staticClass: "like-button__icon material-icons-outlined"
            }, [t._v("add")]), t._v(" " + t._s(t.$t("archive")) + " ")])])])], 1), n("hr", {
                staticClass: "divider"
            })])
        }
          , di = []
          , pi = (n("2b3d"),
        n("9861"),
        function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "editor",
                class: {
                    "editor--editable": t.editable,
                    "editor--focused": t.editor.focused
                }
            }, [t.imgError && !t.editable ? n("blockquote", [n("p", [n("strong", [t._v(t._s(t.$t("img-invalid-title")))])]), n("p", [t._v(t._s(t.$t("img-invalid-subtitle")))])]) : t._e(), n("EditorMenuBar", {
                directives: [{
                    name: "show",
                    rawName: "v-show",
                    value: t.editable,
                    expression: "editable"
                }],
                attrs: {
                    editor: t.editor
                },
                scopedSlots: t._u([{
                    key: "default",
                    fn: function(e) {
                        var a = e.commands
                          , i = e.isActive;
                        return n("div", {
                            staticClass: "editor-menu-bar"
                        }, [n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.bold()
                            },
                            on: {
                                click: a.bold
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("format_bold")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.italic()
                            },
                            on: {
                                click: a.italic
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("format_italic")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.strike()
                            },
                            on: {
                                click: a.strike
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("format_strikethrough")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.underline()
                            },
                            on: {
                                click: a.underline
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("format_underline")])])]), n("button", {
                            staticClass: "menubar__button",
                            on: {
                                click: function(e) {
                                    return t.showLinkDialog()
                                }
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("link")])])]), n("button", {
                            staticClass: "menubar__button",
                            on: {
                                click: a.horizontal_rule
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("horizontal_rule")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.code()
                            },
                            on: {
                                click: a.code
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("code")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.heading({
                                    level: 1
                                })
                            },
                            on: {
                                click: function(t) {
                                    return a.heading({
                                        level: 1
                                    })
                                }
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("looks_one")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.heading({
                                    level: 2
                                })
                            },
                            on: {
                                click: function(t) {
                                    return a.heading({
                                        level: 2
                                    })
                                }
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("looks_two")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.heading({
                                    level: 3
                                })
                            },
                            on: {
                                click: function(t) {
                                    return a.heading({
                                        level: 3
                                    })
                                }
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("looks_3")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.bullet_list()
                            },
                            on: {
                                click: a.bullet_list
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("format_list_bulleted")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.ordered_list()
                            },
                            on: {
                                click: a.ordered_list
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("format_list_numbered")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.blockquote()
                            },
                            on: {
                                click: a.blockquote
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("format_quote")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {
                                "is-active": i.code_block()
                            },
                            on: {
                                click: a.code_block
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("code")])])]), n("button", {
                            staticClass: "menubar__button",
                            on: {
                                click: function(e) {
                                    return t.$emit("open-image-upload")
                                }
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("image")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {},
                            on: {
                                click: a.undo
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("undo")])])]), n("button", {
                            staticClass: "menubar__button",
                            class: {},
                            on: {
                                click: a.redo
                            }
                        }, [n("span", {
                            staticClass: "icon"
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("redo")])])])])
                    }
                }])
            }), n("div", {
                staticClass: "content"
            }, [t.editable ? n("EditorContent", {
                staticClass: "editor-content",
                attrs: {
                    editor: t.editor
                }
            }) : n("div", {
                staticClass: "editor-content",
                attrs: {
                    editor: t.editor
                },
                domProps: {
                    innerHTML: t._s(t.getVhtmlContent())
                }
            })], 1), t.editable ? n("div", {
                staticClass: "dialogs"
            }, [n("TheTextEditorLinkDialog", {
                ref: "linkDialog"
            })], 1) : t._e()], 1)
        }
        )
          , mi = []
          , fi = (n("5319"),
        n("4e82"),
        n("cd42"))
          , hi = n("f23d")
          , _i = n("262e")
          , bi = n("2caf")
          , vi = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "image-container"
            }, [n("div", {
                staticClass: "dropdown is-hoverable is-up"
            }, [n("div", {
                staticClass: "dropdown-trigger material-icons"
            }, [t._v(" drag_indicator ")]), n("div", {
                staticClass: "dropdown-menu"
            }, [n("div", {
                staticClass: "dropdown-content"
            }, t._l(t.sizes, (function(e, a) {
                return n("div", {
                    key: a,
                    staticClass: "dropdown-item",
                    class: {
                        selected: t.width === e
                    },
                    on: {
                        click: function(n) {
                            return t.resize(e)
                        }
                    }
                }, [t._v(" " + t._s(t.$t(a)) + " ")])
            }
            )), 0)])]), n("img", {
                staticClass: "image",
                attrs: {
                    src: t.src,
                    alt: t.alt,
                    title: t.title,
                    width: t.width
                },
                on: {
                    error: t.imageLoadError
                }
            })])
        }
          , gi = []
          , yi = {
            name: "TheAttachmentImage",
            props: {
                node: Object,
                updateAttrs: Function,
                view: Object,
                options: Object
            },
            data: function() {
                return {
                    sizes: {
                        small: 250,
                        mid: 500,
                        large: 1e3
                    }
                }
            },
            computed: {
                src: function() {
                    return this.node.attrs.src
                },
                alt: function() {
                    return this.node.attrs.alt
                },
                title: function() {
                    return this.node.attrs.title
                },
                width: function() {
                    return this.node.attrs.width
                },
                "data-attachment": {
                    get: function() {
                        return this.node.attrs["data-attachment"]
                    }
                }
            },
            methods: {
                imageLoadError: function() {
                    this.options.errorCallback && this.options.errorCallback()
                },
                resize: function(t) {
                    this.updateAttrs({
                        width: t
                    })
                }
            }
        }
          , ki = yi
          , Ci = (n("7ea7"),
        n("8b99"))
          , wi = Object(y["a"])(ki, vi, gi, !1, null, "fd395ac8", null);
        "function" === typeof Ci["default"] && Object(Ci["default"])(wi);
        var xi = wi.exports
          , Ai = function(t) {
            Object(_i["a"])(n, t);
            var e = Object(bi["a"])(n);
            function n() {
                return Object(x["a"])(this, n),
                e.apply(this, arguments)
            }
            return Object(A["a"])(n, [{
                key: "name",
                get: function() {
                    return "attachmentImage"
                }
            }, {
                key: "schema",
                get: function() {
                    return {
                        inline: !0,
                        attrs: {
                            src: {},
                            alt: {
                                default: null
                            },
                            title: {
                                default: null
                            },
                            width: {
                                default: 500
                            },
                            "data-attachment": {
                                default: null
                            }
                        },
                        group: "inline",
                        draggable: !0,
                        parseDOM: [{
                            tag: this.options.editable ? "img[src][data-attachment]" : "img[src]",
                            getAttrs: function(t) {
                                return {
                                    src: t.getAttribute("src"),
                                    title: t.getAttribute("title"),
                                    alt: t.getAttribute("alt"),
                                    width: t.getAttribute("width"),
                                    "data-attachment": t.getAttribute("data-attachment")
                                }
                            }
                        }],
                        toDOM: function(t) {
                            return ["img", t.attrs]
                        }
                    }
                }
            }, {
                key: "commands",
                value: function(t) {
                    var e = t.type;
                    return function(t) {
                        return function(n, a) {
                            var i = n.selection
                              , o = i.$cursor ? i.$cursor.pos : i.$to.pos
                              , s = e.create(t)
                              , r = n.tr.insert(o, s);
                            a(r)
                        }
                    }
                }
            }, {
                key: "view",
                get: function() {
                    return xi
                }
            }]),
            n
        }(fi["f"])
          , Oi = n("a9de")
          , Si = function(t) {
            Object(_i["a"])(n, t);
            var e = Object(bi["a"])(n);
            function n() {
                return Object(x["a"])(this, n),
                e.apply(this, arguments)
            }
            return Object(A["a"])(n, [{
                key: "keys",
                value: function(t) {
                    var e = t.type;
                    return {
                        "Shift-Ctrl-\\": Object(Oi["k"])(e),
                        Tab: function(t, n) {
                            var a = t.selection.$from;
                            return a.node().type === e && (Object(Oi["c"])("\t")(t, n),
                            !0)
                        }
                    }
                }
            }]),
            n
        }(hi["e"])
          , $i = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("a", {
                staticClass: "bookmark-box",
                attrs: {
                    href: t.href,
                    target: "_blank"
                }
            }, [n("p", {
                staticClass: "box-title"
            }, [t._v(" " + t._s(t.title) + " "), n("i", {
                staticClass: "material-icons icon"
            }, [t._v("navigate_next")])]), n("p", {
                staticClass: "box-info"
            }, [t._v(" " + t._s(t.href.length > 50 ? t.href.substring(0, 50) + "..." : t.href) + " ")])])
        }
          , ji = [];
        function Ti(t, e, n) {
            var a = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=+$,\w]+@)?[A-Za-z0-9.-]+|(?:www\.|[-;:&=+$,\w]+@)[A-Za-z0-9.-]+)((?:\/[+~%/.\w\-_]*)?\??(?:[-+=&;%@.\w_]*)#?(?:[.!/\\\w]*))?)/g
              , i = []
              , o = []
              , s = null;
            if (n || e) {
                while (null !== (s = a.exec(t)))
                    i.push(s);
                var r, c = Object(H["a"])(i);
                try {
                    for (c.s(); !(r = c.n()).done; ) {
                        var l = r.value;
                        e ? o.push([l[0], l.length > 3 ? l[0].replace(l[3], "") : l[0]]) : Ei(l[0], o)
                    }
                } catch (u) {
                    c.e(u)
                } finally {
                    c.f()
                }
            } else
                Ei(t, o);
            return n ? o : o.length > 0 ? o[0] : null
        }
        function Ei(t, e) {
            var n = ["http:", "https:"];
            try {
                var a = new URL(t);
                n.includes(a.protocol) && e.push([a.href, a.hostname])
            } catch (i) {}
        }
        var Ii = {
            name: "ThePostBookmark",
            props: {
                node: Object
            },
            computed: {
                href: function() {
                    return this.node.attrs.href
                },
                title: function() {
                    var t = this.node.attrs.title;
                    if (!t || 0 === t.replace(" ", "").length)
                        return "URL";
                    var e = Ti(t, !0);
                    if (e) {
                        var n = e[1].split(".");
                        n.pop();
                        var a, i = Object(H["a"])(n.reverse());
                        try {
                            for (i.s(); !(a = i.n()).done; ) {
                                var o = a.value;
                                if (o.length > 2)
                                    return o.toUpperCase()
                            }
                        } catch (s) {
                            i.e(s)
                        } finally {
                            i.f()
                        }
                    }
                    return t
                }
            }
        }
          , Pi = Ii
          , Ni = (n("a2de"),
        Object(y["a"])(Pi, $i, ji, !1, null, "3fc8d1c4", null))
          , Ri = Ni.exports
          , Bi = function(t) {
            Object(_i["a"])(n, t);
            var e = Object(bi["a"])(n);
            function n() {
                return Object(x["a"])(this, n),
                e.apply(this, arguments)
            }
            return Object(A["a"])(n, [{
                key: "schema",
                get: function() {
                    return {
                        attrs: {
                            href: {
                                default: null
                            },
                            title: {
                                default: null
                            }
                        },
                        inline: "true",
                        group: "inline",
                        draggable: !0,
                        parseDOM: [{
                            priority: 51,
                            tag: "a[data-bookmark][href]",
                            getAttrs: function(t) {
                                var e = t.getAttribute("href");
                                return {
                                    href: e,
                                    title: t.innerText
                                }
                            }
                        }],
                        toDOM: function(t) {
                            return ["a", {
                                href: t.attrs.href,
                                "data-bookmark": !0
                            }, t.attrs.title]
                        }
                    }
                }
            }, {
                key: "commands",
                value: function(t) {
                    var e = t.type;
                    return function(t) {
                        return function(n, a) {
                            var i = n.selection
                              , o = i.$cursor ? i.$cursor.pos : i.$to.pos
                              , s = e.create(t)
                              , r = n.tr.insert(o, s);
                            a(r)
                        }
                    }
                }
            }, {
                key: "name",
                get: function() {
                    return "linkBookmark"
                }
            }, {
                key: "view",
                get: function() {
                    return Ri
                }
            }]),
            n
        }(fi["f"])
          , Li = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("TextEditorDialog", {
                ref: "root",
                staticClass: "link-dialog"
            }, [n("span", {
                attrs: {
                    slot: "title"
                },
                slot: "title"
            }, [t._v(" " + t._s(t.$t("link-attach")) + " ")]), n("div", {
                staticClass: "link-dialog__section"
            }, [n("input", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.url,
                    expression: "url"
                }],
                staticClass: "input",
                class: {
                    "is-empty": 0 === t.url.length
                },
                attrs: {
                    placeholder: t.$t("link-url"),
                    type: "text"
                },
                domProps: {
                    value: t.url
                },
                on: {
                    input: function(e) {
                        e.target.composing || (t.url = e.target.value)
                    }
                }
            }), n("input", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.title,
                    expression: "title"
                }],
                staticClass: "input",
                class: {
                    "is-empty": 0 === t.title.length
                },
                attrs: {
                    placeholder: t.$t("link-title"),
                    type: "text"
                },
                domProps: {
                    value: t.title
                },
                on: {
                    input: function(e) {
                        e.target.composing || (t.title = e.target.value)
                    }
                }
            })]), n("div", {
                staticClass: "link-dialog__buttons"
            }, [n("button", {
                staticClass: "button link-dialog__button",
                on: {
                    click: function(e) {
                        return t.hideDialog(t.url, t.titleDefault, !1)
                    }
                }
            }, [t._v(" " + t._s(t.$t("link-add")) + " ")]), n("button", {
                staticClass: "button link-dialog__button link-dialog__button--primary",
                on: {
                    click: function(e) {
                        return t.hideDialog(t.url, t.titleDefault, !0)
                    }
                }
            }, [t._v(" " + t._s(t.$t("bookmark-add")) + " ")])])])
        }
          , Di = []
          , Ui = (n("00b4"),
        function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "text-editor-dialog"
            }, [n("transition", {
                attrs: {
                    name: "dialog-fade"
                }
            }, [t.shown ? n("div", {
                staticClass: "text-editor-dialog__inner"
            }, [n("div", {
                staticClass: "text-editor-dialog__backdrop",
                on: {
                    click: function(e) {
                        return t.hideDialog()
                    }
                }
            }), n("section", {
                staticClass: "dialog"
            }, [n("header", {
                staticClass: "dialog__header"
            }, [n("h2", {
                staticClass: "dialog__title"
            }, [t._t("title")], 2), n("a", {
                staticClass: "dialog__close",
                on: {
                    click: function(e) {
                        return t.hideDialog()
                    }
                }
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("close")])])]), n("div", {
                staticClass: "dialog__content"
            }, [t._t("default")], 2)])]) : t._e()])], 1)
        }
        )
          , Mi = []
          , qi = {
            name: "TextEditorDialog",
            data: function() {
                return {
                    shown: !1,
                    callback: null
                }
            },
            computed: {
                dialogShown: function() {
                    return this.shown
                }
            },
            methods: {
                showDialog: function(t) {
                    this.shown = !0,
                    this.callback = t
                },
                hideDialog: function() {
                    this.shown = !1,
                    this.callback.apply(this, arguments)
                }
            }
        }
          , zi = qi
          , Ki = (n("55bf"),
        Object(y["a"])(zi, Ui, Mi, !1, null, "a63abb4e", null))
          , Wi = Ki.exports
          , Hi = {
            name: "TheTextEditorLinkDialog",
            components: {
                TextEditorDialog: Wi
            },
            data: function() {
                return {
                    url: "",
                    title: ""
                }
            },
            computed: {
                urlEmpty: function() {
                    return 0 === this.url.length
                },
                titleDefault: function() {
                    return this.title.trim() ? this.title : this.url
                }
            },
            methods: {
                showDialog: function(t, e) {
                    this.url = "",
                    this.title = e,
                    this.$refs.root && this.$refs.root.showDialog(t)
                },
                hideDialog: function() {
                    var t;
                    /^https?:\/\//.test(this.url) ? this.$refs.root && (t = this.$refs.root).hideDialog.apply(t, arguments) : this.$store.dispatch("dialog/toast", {
                        title: this.$t("wrong-url"),
                        type: "error",
                        text: this.$t("wrong-url-desc")
                    })
                }
            }
        }
          , Fi = Hi
          , Vi = (n("4634"),
        n("7408"))
          , Qi = Object(y["a"])(Fi, Li, Di, !1, null, "68786af6", null);
        "function" === typeof Vi["default"] && Object(Vi["default"])(Qi);
        var Ji = Qi.exports
          , Gi = {
            name: "TheTextEditor",
            components: {
                EditorContent: fi["b"],
                EditorMenuBar: fi["c"],
                TheTextEditorLinkDialog: Ji
            },
            props: {
                content: {
                    type: String,
                    default: ""
                },
                editable: Boolean
            },
            data: function() {
                var t = this;
                return {
                    imgError: !1,
                    editor: new fi["a"]({
                        extensions: [new Bi, new Ai({
                            errorCallback: function() {
                                t.imgError = !0
                            },
                            editable: this.editable
                        }), new hi["a"], new hi["b"], new hi["c"], new hi["d"], new Si, new hi["f"], new hi["g"]({
                            levels: [1, 2, 3]
                        }), new hi["h"], new hi["i"], new hi["k"], new hi["j"], new hi["l"], new hi["m"], new hi["n"]({
                            emptyNodeClass: "is-empty",
                            emptyNodeText: "Write something …",
                            showOnlyWhenEditable: !0
                        }), new hi["o"], new hi["p"], new hi["r"], new hi["q"], new hi["s"], new hi["t"]],
                        content: this.content,
                        editable: this.editable
                    })
                }
            },
            watch: {
                content: function(t) {
                    this.editable || this.editor.setContent(t)
                }
            },
            beforeDestroy: function() {
                this.editor.destroy()
            },
            methods: {
                getContent: function() {
                    return this.editor.getHTML()
                },
                getVhtmlContent: function() {
                    var t = this.editor.getHTML()
                      , e = /<p><\/p>/g;
                    return t.replace(e, "<br>")
                },
                showLinkDialog: function() {
                    var t = this
                      , e = this.editor
                      , n = e.commands
                      , a = e.schema
                      , i = e.view
                      , o = e.selection
                      , s = e.state.doc
                      , r = o.from
                      , c = o.to
                      , l = s.textBetween(r, c, " ");
                    this.$refs.linkDialog.showDialog((function(e, o, s) {
                        var r = t.editor.state.tr;
                        if (s)
                            n.linkBookmark({
                                href: e,
                                title: o
                            });
                        else {
                            var c = a.text(o, [a.marks.link.create({
                                href: e
                            })]);
                            i.dispatch(r.replaceSelectionWith(c, !1))
                        }
                    }
                    ), l || "")
                },
                addImageByFile: function(t) {
                    t.blobUrl && this.editor.commands.attachmentImage({
                        src: t.blobUrl,
                        "data-attachment": t.key
                    })
                },
                removeImageByFile: function(t) {
                    var e = [];
                    if (this.editor.state.doc.descendants((function(n, a) {
                        return "attachmentImage" !== n.type.name || (n.attrs["data-attachment"] === t.key ? (e.push(a),
                        !1) : void 0)
                    }
                    )),
                    !(e.length <= 0)) {
                        var n = e.sort((function(t, e) {
                            return e - t
                        }
                        )).reduce((function(t, e) {
                            return t.delete(e, e + 1)
                        }
                        ), this.editor.state.tr);
                        this.editor.view.dispatch(n.setMeta("addToHistory", !1))
                    }
                },
                applyImageUpload: function(t) {
                    this.editor.state.doc.descendants((function(e) {
                        if ("attachmentImage" !== e.type.name)
                            return !0;
                        var n = e.attrs["data-attachment"]
                          , a = t[n];
                        a && (e.attrs["data-attachment"] = a.id,
                        e.attrs.src = a.file)
                    }
                    ))
                }
            }
        }
          , Yi = Gi
          , Zi = (n("35d1"),
        n("5dee"),
        n("e792"))
          , Xi = Object(y["a"])(Yi, pi, mi, !1, null, "605472e2", null);
        "function" === typeof Zi["default"] && Object(Zi["default"])(Xi);
        var to = Xi.exports
          , eo = {
            name: "ThePostDetail",
            components: {
                LikeButton: Fa,
                TextEditor: to,
                ThePostBookmark: Ri
            },
            props: {
                post: {
                    type: Object,
                    required: !0
                }
            },
            data: function() {
                return {
                    attachments: null
                }
            },
            computed: Object(U["a"])({
                userPictureUrl: function() {
                    return this.post.created_by && this.post.created_by.profile.picture
                },
                postAuthor: function() {
                    return this.post.created_by && this.post.created_by.profile.nickname
                },
                postAuthorId: function() {
                    return this.post.created_by && this.post.created_by.id
                },
                postId: function() {
                    return this.post && this.post.id
                },
                content: function() {
                    return this.post.content
                },
                isBlocked: function() {
                    return this.post.created_by && this.post.created_by.is_blocked
                },
                isMine: function() {
                    return this.post && this.post.is_mine
                },
                isRegular: function() {
                    return 1 === this.post.name_type
                },
                isNotRealName: function() {
                    return 4 !== this.post.name_type
                },
                hiddenReason: function() {
                    var t = '<div class="has-text-weight-bold"> '.concat(this.post.why_hidden.map((function(t) {
                        return b.t(t)
                    }
                    )).join("<br>"), "</div>")
                      , e = this.post.can_override_hidden ? "<div>(".concat(this.$t("hidden-notice-" + this.post.why_hidden[0]), ")</div>") : "";
                    return t + e
                },
                hidden_icon: function() {
                    switch (this.post.why_hidden[0]) {
                    case "ADULT_CONTENT":
                        return "visibility_off";
                    case "SOCIAL_CONTENT":
                        return "visibility_off";
                    case "REPORTED_CONTENT":
                        return "warning";
                    case "BLOCKED_USER_CONTENT":
                        return "voice_over_off";
                    default:
                        return "help_outline"
                    }
                }
            }, Object(M["c"])(["userId"])),
            watch: {
                "post.attachments": {
                    handler: function(t) {
                        var e = this;
                        return Object(u["a"])(p.a.mark((function n() {
                            return p.a.wrap((function(n) {
                                while (1)
                                    switch (n.prev = n.next) {
                                    case 0:
                                        if (t) {
                                            n.next = 2;
                                            break
                                        }
                                        return n.abrupt("return");
                                    case 2:
                                        e.attachments = t.map((function(t) {
                                            var e = t.id
                                              , n = t.file;
                                            return {
                                                id: e,
                                                url: n,
                                                file: decodeURIComponent(new URL(n).pathname.split("/").pop())
                                            }
                                        }
                                        ));
                                    case 3:
                                    case "end":
                                        return n.stop()
                                    }
                            }
                            ), n)
                        }
                        )))()
                    },
                    immediate: !0
                }
            },
            methods: {
                deletePost: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        var n;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return e.next = 2,
                                    t.$store.dispatch("dialog/confirm", t.$t("confirm-delete"));
                                case 2:
                                    if (n = e.sent,
                                    n) {
                                        e.next = 5;
                                        break
                                    }
                                    return e.abrupt("return");
                                case 5:
                                    return e.next = 7,
                                    bt(t.post.id);
                                case 7:
                                    t.$router.go(-1);
                                case 8:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                }
            }
        }
          , no = eo
          , ao = (n("d2d3"),
        n("9a8f"))
          , io = Object(y["a"])(no, ui, di, !1, null, "186434ed", null);
        "function" === typeof ao["default"] && Object(ao["default"])(io);
        var oo = io.exports
          , so = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "post"
            }, [n("div", {
                staticClass: "title"
            }, [n("a", {
                staticClass: "title__board"
            }, [n("div", {
                staticClass: "title__board",
                on: {
                    click: function(e) {
                        t.beforeBoardName === t.$t("prev-page") ? t.$router.back() : t.$router.push(t.beforeBoard)
                    }
                }
            }, [n("i", {
                staticClass: "material-icons title__board--icon"
            }, [t._v("arrow_back_ios")]), n("span", {
                staticClass: "title__board--name"
            }, [t._v(" " + t._s(t.beforeBoardName) + " ")])]), t.beforeBoardName === t.$t("all") ? n("span", {
                staticClass: "title__info"
            }, [n("router-link", {
                staticClass: "title__info",
                attrs: {
                    to: {
                        name: "board",
                        params: {
                            boardSlug: t.boardSlug
                        }
                    }
                }
            }, [t._v(" | " + t._s(t.boardName) + " ")])], 1) : t._e()]), n("hr", {
                staticClass: "title__divider"
            }), n("span", {
                staticClass: "title__text"
            }, [t.post.parent_topic ? n("span", {
                staticClass: "title__topic"
            }, [t._v(" [" + t._s(t.post.parent_topic[t.$i18n.locale + "_name"]) + "] ")]) : t._e(), t._v(" " + t._s(t.title) + " "), n("span", {
                staticClass: "title__comments"
            }, [t._v(" (" + t._s(t.post.comment_count) + ") ")])]), n("span", {
                staticClass: "title__detail"
            }, [n("span", {
                staticClass: "title__date"
            }, [t._v(" 작성일 · " + t._s(t.postCreatedAt) + " ")]), n("span", {
                staticClass: "title__hit"
            }, [t._v(" 조회수 · " + t._s(t.post.hit_count) + " ")]), n("span", {
                staticClass: "board-item__author status"
            }, [t.isCommunicationPost ? n("span", {
                staticClass: "status--button",
                class: {
                    polling: 0 === t.status,
                    preparing: 1 === t.status,
                    answered: 2 === t.status
                }
            }, [t._v(" " + t._s(t.statusText) + " ")]) : t._e(), t.dday && t.isCommunicationAdmin ? n("span", {
                staticClass: "d-day"
            }, [t._v(" " + t._s(t.dday) + " ")]) : t._e()])])]), n("div", {
                staticClass: "metadata"
            }, [n(t.isRegular ? "router-link" : "span", {
                tag: "router-link",
                staticClass: "author",
                attrs: {
                    to: {
                        name: "user",
                        params: {
                            username: t.postAuthorId
                        }
                    }
                }
            }, [n("img", {
                staticClass: "author__picture",
                attrs: {
                    src: t.userPictureUrl
                }
            }), n("span", {
                staticClass: "author__nickname"
            }, [t._v(t._s(t.postAuthor))]), t.isRegular ? n("i", {
                staticClass: "author__icon material-icons"
            }, [t._v("chevron_right")]) : t._e()]), t.post.is_hidden ? t._e() : n("LikeButton", {
                staticClass: "metadata__like",
                attrs: {
                    item: t.post,
                    votable: "",
                    "is-mine": t.post.is_mine
                },
                on: {
                    vote: function(e) {
                        return t.$emit("vote", e)
                    }
                }
            })], 1), n("hr", {
                staticClass: "divider"
            })])
        }
          , ro = []
          , co = (n("2532"),
        {
            name: "ThePostHeader",
            components: {
                LikeButton: Fa
            },
            props: {
                post: {
                    type: Object,
                    required: !0
                },
                context: Object
            },
            data: function() {
                return {
                    attachments: null
                }
            },
            computed: Object(U["a"])(Object(U["a"])({}, Object(M["c"])(["isCommunicationAdmin", "userPicture"])), {}, {
                dday: function() {
                    if (1 === this.status)
                        return 0 === this.post.days_left ? "D-Day" : this.post.days_left > 0 ? "D-".concat(this.post.days_left) : "기간 경과"
                },
                status: function() {
                    var t;
                    return null !== (t = this.post.communication_article_status) && void 0 !== t ? t : 0
                },
                isCommunicationPost: function() {
                    var t;
                    return 14 === (null === (t = this.post.parent_board) || void 0 === t ? void 0 : t.id)
                },
                statusText: function() {
                    var t = ["polling", "preparing", "answered"][this.status];
                    return this.$t("status.".concat(t)).toString()
                },
                userPictureUrl: function() {
                    return this.post.created_by && this.post.created_by.profile.picture
                },
                postAuthor: function() {
                    return this.post.created_by && this.post.created_by.profile.nickname
                },
                postAuthorId: function() {
                    return this.post.created_by && this.post.created_by.id
                },
                postCreatedAt: function() {
                    return nt(this.post.created_at)
                },
                boardSlug: function() {
                    return this.post.parent_board && this.post.parent_board.slug
                },
                boardName: function() {
                    return this.post.parent_board && this.post.parent_board["".concat(this.$i18n.locale, "_name")]
                },
                title: function() {
                    return this.post.is_hidden ? b.t(this.post.why_hidden[0]) : this.post.title
                },
                isRegular: function() {
                    return 1 === this.post.name_type
                },
                beforeBoard: function() {
                    var t = this.$route.query
                      , e = t.from_view
                      , n = t.topic_id
                      , a = t.current
                      , i = "board"
                      , o = {
                        boardSlug: this.boardSlug
                    }
                      , s = {
                        page: a
                    };
                    return "board" === e ? {
                        name: i,
                        params: o,
                        query: s
                    } : "topic" === e ? {
                        name: i,
                        params: o,
                        query: Object(U["a"])(Object(U["a"])({}, s), {}, {
                            topic: n
                        })
                    } : "scrap" === e ? {
                        name: "my-info",
                        query: Object(U["a"])({
                            board: "archive"
                        }, s)
                    } : "recent" === e ? {
                        name: "my-info",
                        query: Object(U["a"])({
                            board: "recent"
                        }, s)
                    } : "-portal" === e ? {
                        name: i,
                        query: Object(U["a"])(Object(U["a"])({}, s), {}, {
                            portal: "exclude"
                        })
                    } : {
                        name: i,
                        query: s
                    }
                },
                beforeBoardName: function() {
                    var t = this.$route.query.from_view;
                    return "board" === t || "topic" === t ? this.boardName : "scrap" === t ? this.$t("archive-board") : "recent" === t ? this.$t("recent-board") : this.hasHistory() ? "all" === t ? this.$t("all") : this.$t("prev-page") : this.$t("all")
                }
            }, Object(M["c"])(["userId"])),
            methods: {
                hasHistory: function() {
                    return window.history.length > 3 || document.referrer && (document.referrer.includes("sparcs.org") || document.referrer.includes("localhost"))
                }
            }
        })
          , lo = co
          , uo = (n("28c2"),
        n("2aba"))
          , po = Object(y["a"])(lo, so, ro, !1, null, "48439a47", null);
        "function" === typeof uo["default"] && Object(uo["default"])(po);
        var mo = po.exports
          , fo = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return t.sideArticlesEnabled ? n("div", {
                staticClass: "post-navigation"
            }, [t.post.side_articles.after ? n("BoardItem", {
                attrs: {
                    post: t.post.side_articles.after,
                    "from-query": t.$route.query
                }
            }) : t._e(), n("BoardItem", {
                staticClass: "post-navigation__current",
                attrs: {
                    post: t.post,
                    "from-query": t.$route.query
                }
            }), t.post.side_articles.before ? n("BoardItem", {
                attrs: {
                    post: t.post.side_articles.before,
                    "from-query": t.$route.query
                }
            }) : t._e()], 1) : t._e()
        }
          , ho = []
          , _o = {
            name: "ThePostNavigation",
            components: {
                BoardItem: Hn
            },
            props: {
                post: {
                    type: Object,
                    required: !0
                },
                context: Object
            },
            computed: {
                sideArticlesEnabled: function() {
                    return this.post.side_articles && (this.post.side_articles.before || this.post.side_articles.after)
                }
            }
        }
          , bo = _o
          , vo = (n("92f2"),
        Object(y["a"])(bo, fo, ho, !1, null, "585652d2", null))
          , go = vo.exports
          , yo = {
            name: "Post",
            components: {
                TheLayout: pn,
                ThePostComments: li,
                ThePostDetail: oo,
                ThePostHeader: mo,
                ThePostNavigation: go,
                TheSidebar: ka
            },
            props: {
                postId: {
                    type: [String, Number],
                    required: !0
                }
            },
            data: function() {
                return {
                    post: {}
                }
            },
            computed: {
                context: function() {
                    var t, e = this.$route.query, n = e.from_view, a = e.current, i = e.search_query, o = {};
                    (a && (o.page = a),
                    i && (o.query = i),
                    "topic" === n) && (o.topic = null === (t = this.post.parent_topic) || void 0 === t ? void 0 : t.slug);
                    switch (n) {
                    case "user":
                        return {
                            name: "user",
                            params: {
                                username: this.$route.query.created_by
                            },
                            query: o
                        };
                    case "recent":
                        return o.board = "recent",
                        {
                            name: "my-info",
                            query: o
                        };
                    case "scrap":
                        return {
                            name: "archive",
                            query: o
                        };
                    case "all":
                        return {
                            name: "board",
                            query: o
                        };
                    case "-portal":
                        return {
                            name: "board",
                            query: Object(U["a"])(Object(U["a"])({}, o), {}, {
                                portal: "exclude"
                            })
                        };
                    default:
                        return {
                            name: "board",
                            params: {
                                boardSlug: this.post.parent_board ? this.post.parent_board.slug : null
                            },
                            query: o
                        }
                    }
                },
                postURL: function() {
                    var t = "[".concat(this.post.title, "]")
                      , e = window.location.origin + "/post/" + this.postId;
                    return t + " " + e
                }
            },
            beforeRouteEnter: function(t, e, n) {
                return Object(u["a"])(p.a.mark((function e() {
                    var a, i, o, s, r;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return a = t.params.postId,
                                i = t.query,
                                e.next = 3,
                                De([dt({
                                    postId: a,
                                    context: i
                                })], "post-failed-fetch");
                            case 3:
                                o = e.sent,
                                s = Object(V["a"])(o, 1),
                                r = s[0],
                                n((function(t) {
                                    t.post = r,
                                    document.title = "Ara - ".concat(r.is_hidden ? t.$t("hidden-post") : r.title)
                                }
                                ));
                            case 7:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            beforeRouteUpdate: function(t, e, n) {
                var a = this;
                return Object(u["a"])(p.a.mark((function e() {
                    var i, o, s, r, c;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return i = t.params.postId,
                                o = t.query,
                                e.next = 3,
                                De([dt({
                                    postId: i,
                                    context: o
                                })], "post-failed-fetch");
                            case 3:
                                s = e.sent,
                                r = Object(V["a"])(s, 1),
                                c = r[0],
                                document.title = "Ara - ".concat(c.is_hidden ? a.$t("hidden-post") : c.title),
                                a.post = c,
                                n();
                            case 9:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            methods: {
                addNewComment: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    t.is_mine = !0,
                                    t.created_by.profile.nickname = e.post.my_comment_profile.profile.nickname,
                                    t.created_by.profile.picture = e.post.my_comment_profile.profile.picture,
                                    t.created_by.id = e.post.my_comment_profile.id,
                                    t.parent_comment ? (a = e.post.comments.find((function(e) {
                                        return e.id === t.parent_comment
                                    }
                                    )),
                                    a.comments = [].concat(Object(L["a"])(a.comments), [t])) : e.post.comments = [].concat(Object(L["a"])(e.post.comments), [t]);
                                case 5:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n)
                    }
                    )))()
                },
                updateComment: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a, i, o;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    if (!t.parent_comment) {
                                        n.next = 10;
                                        break
                                    }
                                    if (a = e.post.comments.find((function(e) {
                                        return e.id === t.parent_comment
                                    }
                                    )),
                                    i = a.comments.findIndex((function(e) {
                                        return e.id === t.id
                                    }
                                    )),
                                    !(i < 0)) {
                                        n.next = 5;
                                        break
                                    }
                                    return n.abrupt("return");
                                case 5:
                                    return t.created_by.profile = a.comments[i].created_by.profile,
                                    t.created_by.username = a.comments[i].created_by.username,
                                    t.created_by.id = a.comments[i].created_by.id,
                                    e.$set(a.comments, i, t),
                                    n.abrupt("return");
                                case 10:
                                    if (o = e.post.comments.findIndex((function(e) {
                                        return e.id === t.id
                                    }
                                    )),
                                    !(o < 0)) {
                                        n.next = 13;
                                        break
                                    }
                                    return n.abrupt("return");
                                case 13:
                                    t.created_by.profile = e.post.comments[o].created_by.profile,
                                    t.created_by.username = e.post.comments[o].created_by.username,
                                    t.created_by.id = e.post.comments[o].created_by.id,
                                    e.$set(e.post.comments, o, t);
                                case 17:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n)
                    }
                    )))()
                },
                refresh: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return e.next = 2,
                                    dt({
                                        postId: t.postId,
                                        context: t.$route.query
                                    });
                                case 2:
                                    t.post = e.sent;
                                case 3:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                vote: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a, i;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    return a = t.id,
                                    i = t.vote,
                                    n.prev = 1,
                                    n.next = 4,
                                    vt(a, i);
                                case 4:
                                    n.next = 9;
                                    break;
                                case 6:
                                    n.prev = 6,
                                    n.t0 = n["catch"](1),
                                    e.$store.dispatch("dialog/toast", e.$t("nonvotable-myself"));
                                case 9:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n, null, [[1, 6]])
                    }
                    )))()
                },
                archive: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        var n;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    if (!t.post.my_scrap) {
                                        e.next = 7;
                                        break
                                    }
                                    return e.next = 3,
                                    ht(t.post.my_scrap.id);
                                case 3:
                                    t.post.my_scrap = null,
                                    t.$store.dispatch("dialog/toast", {
                                        icon: "check_circle_outline",
                                        text: t.$t("unarchived")
                                    }),
                                    e.next = 12;
                                    break;
                                case 7:
                                    return e.next = 9,
                                    ft(t.post.id);
                                case 9:
                                    n = e.sent,
                                    t.post.my_scrap = n,
                                    t.$store.dispatch("dialog/toast", {
                                        icon: "check_circle_outline",
                                        text: t.$t("archived")
                                    });
                                case 12:
                                    return e.next = 14,
                                    t.$store.dispatch("fetchArchivedPosts");
                                case 14:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                report: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        var n, a, i, o, s, r;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    if (!1 !== t.post.can_override_hidden) {
                                        e.next = 3;
                                        break
                                    }
                                    return t.$store.dispatch("dialog/toast", t.$t("report-unavailable")),
                                    e.abrupt("return");
                                case 3:
                                    return e.next = 5,
                                    t.$store.dispatch("dialog/report", t.$t("confirm-report"));
                                case 5:
                                    if (n = e.sent,
                                    a = n.result,
                                    i = n.selection,
                                    a) {
                                        e.next = 10;
                                        break
                                    }
                                    return e.abrupt("return");
                                case 10:
                                    for (r in o = "others",
                                    s = "",
                                    i)
                                        i[r] && (s += r,
                                        s += ", ");
                                    return s = s.slice(0, -2),
                                    e.prev = 14,
                                    e.next = 17,
                                    _t(t.post.id, o, s);
                                case 17:
                                    t.$store.dispatch("dialog/toast", t.$t("reported")),
                                    e.next = 23;
                                    break;
                                case 20:
                                    e.prev = 20,
                                    e.t0 = e["catch"](14),
                                    t.$store.dispatch("dialog/toast", t.$t("already-reported"));
                                case 23:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e, null, [[14, 20]])
                    }
                    )))()
                },
                block: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        var n;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    if (e.prev = 0,
                                    t.post.created_by.is_blocked) {
                                        e.next = 13;
                                        break
                                    }
                                    return e.next = 4,
                                    t.$store.dispatch("dialog/confirm", t.$t("confirm-block"));
                                case 4:
                                    if (n = e.sent,
                                    n) {
                                        e.next = 7;
                                        break
                                    }
                                    return e.abrupt("return");
                                case 7:
                                    return e.next = 9,
                                    Et(t.post.created_by.id);
                                case 9:
                                    t.post.created_by.is_blocked = !0,
                                    t.$store.dispatch("dialog/toast", t.$t("blocked")),
                                    e.next = 17;
                                    break;
                                case 13:
                                    return e.next = 15,
                                    It(t.post.created_by.id);
                                case 15:
                                    t.post.created_by.is_blocked = !1,
                                    t.$store.dispatch("dialog/toast", t.$t("unblocked"));
                                case 17:
                                    e.next = 22;
                                    break;
                                case 19:
                                    e.prev = 19,
                                    e.t0 = e["catch"](0),
                                    403 === e.t0.response.status && t.$store.dispatch("dialog/toast", t.$t("block-rate-limit"));
                                case 22:
                                    return e.next = 24,
                                    t.refresh();
                                case 24:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e, null, [[0, 19]])
                    }
                    )))()
                },
                copyURL: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    navigator.clipboard.writeText(t.postURL).then((function() {
                                        t.$store.dispatch("dialog/toast", {
                                            icon: "check_circle_outline",
                                            text: t.$t("copy-success")
                                        })
                                    }
                                    ));
                                case 1:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                overrideHidden: function() {
                    var t = this;
                    return Object(u["a"])(p.a.mark((function e() {
                        var n;
                        return p.a.wrap((function(e) {
                            while (1)
                                switch (e.prev = e.next) {
                                case 0:
                                    return e.next = 2,
                                    dt({
                                        postId: t.postId,
                                        context: Object(U["a"])(Object(U["a"])({}, t.$route.query), {}, {
                                            override_hidden: !0
                                        })
                                    });
                                case 2:
                                    n = e.sent,
                                    t.post = Object(U["a"])(Object(U["a"])({}, n), {}, {
                                        comments: t.post.comments,
                                        side_articles: t.post.side_articles
                                    }),
                                    document.title = "Ara - ".concat(t.post.title);
                                case 5:
                                case "end":
                                    return e.stop()
                                }
                        }
                        ), e)
                    }
                    )))()
                },
                overrideHiddenComment: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a, i, o, s, r, c, l, u, d, m, f, h, _, b;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    return a = t.commentId,
                                    n.next = 3,
                                    gt({
                                        commentId: a,
                                        context: Object(U["a"])(Object(U["a"])({}, e.$route.query), {}, {
                                            override_hidden: !0
                                        })
                                    });
                                case 3:
                                    i = n.sent,
                                    o = Object(H["a"])(e.post.comments.entries()),
                                    n.prev = 5,
                                    o.s();
                                case 7:
                                    if ((s = o.n()).done) {
                                        n.next = 32;
                                        break
                                    }
                                    if (r = Object(V["a"])(s.value, 2),
                                    c = r[0],
                                    l = r[1],
                                    l.id !== a) {
                                        n.next = 12;
                                        break
                                    }
                                    return u = Object(U["a"])(Object(U["a"])({}, l), i),
                                    n.abrupt("return", e.$set(e.post.comments, c, u));
                                case 12:
                                    d = Object(H["a"])(l.comments.entries()),
                                    n.prev = 13,
                                    d.s();
                                case 15:
                                    if ((m = d.n()).done) {
                                        n.next = 22;
                                        break
                                    }
                                    if (f = Object(V["a"])(m.value, 2),
                                    h = f[0],
                                    _ = f[1],
                                    _.id !== a) {
                                        n.next = 20;
                                        break
                                    }
                                    return b = Object(U["a"])(Object(U["a"])({}, _), i),
                                    n.abrupt("return", e.$set(e.post.comments[c].comments, h, b));
                                case 20:
                                    n.next = 15;
                                    break;
                                case 22:
                                    n.next = 27;
                                    break;
                                case 24:
                                    n.prev = 24,
                                    n.t0 = n["catch"](13),
                                    d.e(n.t0);
                                case 27:
                                    return n.prev = 27,
                                    d.f(),
                                    n.finish(27);
                                case 30:
                                    n.next = 7;
                                    break;
                                case 32:
                                    n.next = 37;
                                    break;
                                case 34:
                                    n.prev = 34,
                                    n.t1 = n["catch"](5),
                                    o.e(n.t1);
                                case 37:
                                    return n.prev = 37,
                                    o.f(),
                                    n.finish(37);
                                case 40:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n, null, [[5, 34, 37, 40], [13, 24, 27, 30]])
                    }
                    )))()
                }
            }
        }
          , ko = yo
          , Co = n("bbe4")
          , wo = Object(y["a"])(ko, Pa, Na, !1, null, null, null);
        "function" === typeof Co["default"] && Object(Co["default"])(wo);
        var xo = wo.exports
          , Ao = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("TheLayout", {
                key: t.postId
            }, [t.postFetched ? n("ThePostWrite", {
                ref: "write",
                attrs: {
                    post: t.post,
                    saving: t.saving,
                    "empty-warnings": t.emptyWarnings
                },
                on: {
                    "save-post": t.savePost
                }
            }) : t._e()], 1)
        }
          , Oo = []
          , So = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "write"
            }, [n("h1", {
                staticClass: "write__title"
            }, [t._v(" " + t._s(t.writeTitle) + " ")]), n("hr"), n("div", {
                staticClass: "write__row"
            }, [t.isCategoryWarning || t.isBoardWarning ? n("i", {
                staticClass: "material-icons write__warning"
            }, [t._v(" warning ")]) : t._e(), n("div", {
                staticClass: "write__input"
            }, [n("div", {
                staticClass: "select",
                class: {
                    "is-placeholder": !t.boardId
                }
            }, [n("select", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.boardId,
                    expression: "boardId"
                }],
                attrs: {
                    disabled: t.editMode
                },
                on: {
                    change: function(e) {
                        var n = Array.prototype.filter.call(e.target.options, (function(t) {
                            return t.selected
                        }
                        )).map((function(t) {
                            var e = "_value"in t ? t._value : t.value;
                            return e
                        }
                        ));
                        t.boardId = e.target.multiple ? n : n[0]
                    }
                }
            }, [n("option", {
                attrs: {
                    value: "",
                    disabled: "",
                    selected: ""
                }
            }, [t._v(" " + t._s(t.$t("input-board")) + " ")]), t._l(t.boardList, (function(e) {
                return n("option", {
                    key: e.id,
                    domProps: {
                        selected: t.boardId === e.id,
                        value: e.id
                    }
                }, [t._v(" " + t._s(e[t.$i18n.locale + "_name"]) + " ")])
            }
            ))], 2)]), t.isBoardWarning ? n("p", {
                staticClass: "write__help help is-danger"
            }, [t._v(" " + t._s(t.$t("input-board-warning")) + " ")]) : t._e()]), n("div", {
                staticClass: "write__input"
            }, [n("div", {
                staticClass: "select",
                class: {
                    "is-placeholder": t.categoryNotSet
                }
            }, [n("select", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.categoryId,
                    expression: "categoryId"
                }],
                attrs: {
                    disabled: t.editMode
                },
                on: {
                    change: function(e) {
                        var n = Array.prototype.filter.call(e.target.options, (function(t) {
                            return t.selected
                        }
                        )).map((function(t) {
                            var e = "_value"in t ? t._value : t.value;
                            return e
                        }
                        ));
                        t.categoryId = e.target.multiple ? n : n[0]
                    }
                }
            }, [t.boardId ? t._e() : n("option", {
                attrs: {
                    value: "$not-set",
                    disabled: ""
                }
            }, [t._v(" " + t._s(t.$t("input-category")) + " ")]), t.boardId ? n("option", {
                attrs: {
                    value: ""
                }
            }, [t._v(" " + t._s(t.$t("no-category")) + " ")]) : t._e(), t.categoryList.length ? t._l(t.categoryList, (function(e) {
                return n("option", {
                    key: e.id,
                    domProps: {
                        selected: t.categoryId === e.id,
                        value: e.id
                    }
                }, [t._v(" " + t._s(e[t.$i18n.locale + "_name"]) + " ")])
            }
            )) : t._e()], 2)]), t.isCategoryWarning ? n("p", {
                staticClass: "write__help help is-danger"
            }, [t._v(" " + t._s(t.$t("input-category-warning")) + " ")]) : t._e()]), n("div", {
                staticClass: "write__input write__content-checkbox"
            }, [7 === t.boardId ? n("label", {
                staticClass: "checkbox"
            }, [t._v(" " + t._s(t.$t("is-anonymous")) + " "), n("input", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.isAnonymous,
                    expression: "isAnonymous"
                }],
                attrs: {
                    type: "checkbox",
                    disabled: t.editMode
                },
                domProps: {
                    checked: Array.isArray(t.isAnonymous) ? t._i(t.isAnonymous, null) > -1 : t.isAnonymous
                },
                on: {
                    change: function(e) {
                        var n = t.isAnonymous
                          , a = e.target
                          , i = !!a.checked;
                        if (Array.isArray(n)) {
                            var o = null
                              , s = t._i(n, o);
                            a.checked ? s < 0 && (t.isAnonymous = n.concat([o])) : s > -1 && (t.isAnonymous = n.slice(0, s).concat(n.slice(s + 1)))
                        } else
                            t.isAnonymous = i
                    }
                }
            })]) : t._e(), n("label", {
                staticClass: "checkbox"
            }, [t._v(" " + t._s(t.$t("is-sexual")) + " "), n("input", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.isSexual,
                    expression: "isSexual"
                }],
                attrs: {
                    type: "checkbox"
                },
                domProps: {
                    checked: Array.isArray(t.isSexual) ? t._i(t.isSexual, null) > -1 : t.isSexual
                },
                on: {
                    change: function(e) {
                        var n = t.isSexual
                          , a = e.target
                          , i = !!a.checked;
                        if (Array.isArray(n)) {
                            var o = null
                              , s = t._i(n, o);
                            a.checked ? s < 0 && (t.isSexual = n.concat([o])) : s > -1 && (t.isSexual = n.slice(0, s).concat(n.slice(s + 1)))
                        } else
                            t.isSexual = i
                    }
                }
            })]), n("label", {
                staticClass: "checkbox"
            }, [t._v(" " + t._s(t.$t("is-social")) + " "), n("input", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.isSocial,
                    expression: "isSocial"
                }],
                attrs: {
                    type: "checkbox"
                },
                domProps: {
                    checked: Array.isArray(t.isSocial) ? t._i(t.isSocial, null) > -1 : t.isSocial
                },
                on: {
                    change: function(e) {
                        var n = t.isSocial
                          , a = e.target
                          , i = !!a.checked;
                        if (Array.isArray(n)) {
                            var o = null
                              , s = t._i(n, o);
                            a.checked ? s < 0 && (t.isSocial = n.concat([o])) : s > -1 && (t.isSocial = n.slice(0, s).concat(n.slice(s + 1)))
                        } else
                            t.isSocial = i
                    }
                }
            })])])]), n("div", {
                staticClass: "write__row"
            }, [t.isTitleWarning ? n("i", {
                staticClass: "material-icons write__warning"
            }, [t._v(" warning ")]) : t._e(), n("div", {
                staticClass: "write__input write__title-input"
            }, [n("input", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.title,
                    expression: "title"
                }],
                staticClass: "input",
                class: {
                    "is-empty": t.isTitleWarning
                },
                attrs: {
                    placeholder: t.$t("input-title"),
                    type: "text"
                },
                domProps: {
                    value: t.title
                },
                on: {
                    input: function(e) {
                        e.target.composing || (t.title = e.target.value)
                    }
                }
            })])]), n("div", {
                staticClass: "write__content"
            }, [n("TextEditor", {
                ref: "textEditor",
                attrs: {
                    content: t.initialPostContent,
                    editable: ""
                },
                on: {
                    "attach-files": t.attachFiles,
                    "open-image-upload": t.openImageUpload
                }
            }), t.emptyWarnings.includes("content") ? n("i", {
                staticClass: "material-icons write__warning"
            }, [t._v(" warning ")]) : t._e()], 1), n("div", {
                staticClass: "write__attachment"
            }, [n("Attachments", {
                ref: "attachments",
                attrs: {
                    multiple: ""
                },
                on: {
                    add: t.addAttachments,
                    delete: t.deleteAttachment
                }
            })], 1), n("div", {
                staticClass: "write__footer"
            }, [n("button", {
                staticClass: "button write__publish",
                class: {
                    "is-loading": t.saving
                },
                on: {
                    click: t.savePostByThePostWrite
                }
            }, [t._v(" " + t._s(t.post ? t.$t("write-edit") : t.$t("write-publish")) + " ")])])])
        }
          , $o = []
          , jo = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "attachments",
                class: {
                    "attachments--failed": t.dropzoneFailedReason,
                    "attachments--enabled": t.dropzoneEnabled
                }
            }, [n("div", {
                staticClass: "attachments__header"
            }, [n("h2", {
                staticClass: "attachments__title"
            }, [t._v(" " + t._s(t.$t("upload")) + " ")]), n("button", {
                staticClass: "attachments__upload button",
                on: {
                    click: t.openUpload
                }
            }, [t._v(" " + t._s(t.$t("upload-button")) + " ")])]), n("div", {
                staticClass: "attachments__content"
            }, [n("label", {
                staticClass: "attachments__dropzone dropzone",
                on: {
                    dragover: function(e) {
                        e.stopPropagation(),
                        e.preventDefault(),
                        t.dropzoneEnabled = !0
                    },
                    dragleave: function(e) {
                        e.stopPropagation(),
                        e.preventDefault(),
                        t.dropzoneEnabled = !1
                    },
                    drop: function(e) {
                        return e.stopPropagation(),
                        e.preventDefault(),
                        t.handleDropUpload.apply(null, arguments)
                    }
                }
            }, [n("input", {
                ref: "upload",
                staticClass: "dropzone__upload",
                attrs: {
                    accept: t.accepted,
                    type: "file"
                },
                on: {
                    change: t.handleDialogUpload
                }
            })]), n("span", {
                staticClass: "attachments__message"
            }, [t._v(t._s(t.dropzoneMessage))]), n("transition-group", {
                staticClass: "attachments__filelist",
                attrs: {
                    name: "filelist-fade",
                    tag: "div"
                }
            }, t._l(t.files, (function(e) {
                return n("div", {
                    key: e.key,
                    staticClass: "attachments__file file"
                }, ["image" === e.type ? n("img", {
                    staticClass: "file__thumbnail",
                    attrs: {
                        src: e.blobUrl
                    }
                }) : t._e(), n("div", {
                    staticClass: "file__details"
                }, [t._v(" " + t._s(e.name) + " "), n("button", {
                    staticClass: "file__delete",
                    on: {
                        click: function(n) {
                            return n.preventDefault(),
                            t.deleteFile(e)
                        }
                    }
                }, [n("i", {
                    staticClass: "material-icons"
                }, [t._v("delete_outline")])])])])
            }
            )), 0)], 1), n("input", {
                ref: "imageUpload",
                staticClass: "dropzone__upload",
                attrs: {
                    type: "file",
                    accept: "image/*"
                },
                on: {
                    change: t.handleImageUpload
                }
            })])
        }
          , To = []
          , Eo = ["txt", "docx", "doc", "pptx", "ppt", "pdf", "hwp", "zip", "7z", "png", "jpg", "jpeg", "gif"]
          , Io = {
            name: "TheAttachments",
            data: function() {
                return {
                    dropzoneFailedReason: null,
                    dropzoneEnabled: !1,
                    files: [],
                    pasteListener: null
                }
            },
            computed: {
                accepted: function() {
                    return Eo.map((function(t) {
                        return ".".concat(t)
                    }
                    )).join(",")
                },
                dropzoneMessage: function() {
                    return this.dropzoneFailedReason ? this.$t(this.dropzoneFailedReason) : this.dropzoneEnabled ? this.$t("dropzone-drop") : this.$t("dropzone-normal")
                }
            },
            mounted: function() {
                var t = this;
                this.pasteListener = function(e) {
                    var n = e.clipboardData || window.clipboardData;
                    if (n) {
                        var a = Object(L["a"])(n.items)
                          , i = a.filter((function(t) {
                            return "file" === t.kind
                        }
                        ));
                        if (0 !== i.length) {
                            e.preventDefault(),
                            e.stopPropagation();
                            var o = i.map((function(t) {
                                return t.getAsFile()
                            }
                            ));
                            t.handleUpload(o)
                        }
                    }
                }
                ,
                document.addEventListener("paste", this.pasteListener)
            },
            beforeDestroy: function() {
                this.pasteListener && document.removeEventListener("paste", this.pasteListener)
            },
            destroyed: function() {
                this.files.forEach((function(t) {
                    t.blobUrl && URL.revokeObjectURL(t.blobUrl)
                }
                ))
            },
            methods: {
                init: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    t.forEach((function(t) {
                                        var n = t.id
                                          , a = t.file
                                          , i = t.mimetype
                                          , o = decodeURIComponent(new URL(a).pathname.split("/").pop())
                                          , s = i.split("/")[0];
                                        e.files.push({
                                            key: n,
                                            type: s,
                                            name: o,
                                            url: a,
                                            blobUrl: "image" === s ? a : null,
                                            uploaded: !0
                                        })
                                    }
                                    ));
                                case 1:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n)
                    }
                    )))()
                },
                openUpload: function() {
                    this.$refs.upload.click()
                },
                openImageUpload: function() {
                    this.$refs.imageUpload.click()
                },
                handleUpload: function(t) {
                    var e, n = this, a = Object(L["a"])(t), i = a.reduce((function(t, e) {
                        var n = Object(V["a"])(t, 2)
                          , a = n[0]
                          , i = n[1]
                          , o = e.name.split(".").pop()
                          , s = {
                            key: Math.random().toString(36).slice(2),
                            type: e.type.split("/")[0],
                            name: e.name,
                            file: e,
                            uploaded: !1
                        };
                        return Eo.includes(o) ? ("image" === s.type && (s.blobUrl = URL.createObjectURL(e)),
                        a.push(s),
                        [a, i]) : (i.push(s),
                        [a, i])
                    }
                    ), [[], []]), o = Object(V["a"])(i, 2), s = o[0], r = o[1];
                    r.length > 0 && (this.dropzoneFailedReason = "dropzone-unallowed-extensions",
                    setTimeout((function() {
                        n.dropzoneFailedReason = null
                    }
                    ), 1500)),
                    (e = this.files).push.apply(e, Object(L["a"])(s)),
                    this.$emit("add", s)
                },
                handleDropUpload: function(t) {
                    if (this.dropzoneEnabled = !1,
                    t.dataTransfer) {
                        var e = t.dataTransfer;
                        this.handleUpload(e.files)
                    }
                },
                handleDialogUpload: function(t) {
                    var e = this.$refs.upload.files;
                    e && this.handleUpload(e)
                },
                handleImageUpload: function(t) {
                    var e = this.$refs.imageUpload.files;
                    e && this.handleUpload(e)
                },
                deleteFile: function(t) {
                    var e = this.files.indexOf(t);
                    this.files.splice(e, 1),
                    t.blobUrl && t.blobUrl.startsWith("blob:") && URL.revokeObjectURL(t.blobUrl),
                    this.$emit("delete", t)
                }
            }
        }
          , Po = Io
          , No = (n("fc71"),
        n("3104"))
          , Ro = Object(y["a"])(Po, jo, To, !1, null, "04ae4dea", null);
        "function" === typeof No["default"] && Object(No["default"])(Ro);
        var Bo = Ro.exports
          , Lo = {
            name: "ThePostWrite",
            components: {
                Attachments: Bo,
                TextEditor: to
            },
            props: {
                post: Object,
                saving: Boolean,
                emptyWarnings: Array
            },
            data: function() {
                return {
                    boardId: "",
                    categoryId: "$not-set",
                    title: "",
                    isSexual: !1,
                    isSocial: !1,
                    isAnonymous: !1,
                    loaded: !0
                }
            },
            computed: Object(U["a"])(Object(U["a"])(Object(U["a"])({}, Object(M["d"])({
                boardListAll: "boardList"
            })), Object(M["c"])(["getIdBySlug"])), {}, {
                initialPostContent: function() {
                    return this.post ? this.post.content : null
                },
                boardList: function() {
                    return this.boardListAll.filter((function(t) {
                        return !t.is_readonly && t.user_writable
                    }
                    ))
                },
                board: function() {
                    var t = this;
                    return this.boardListAll.find((function(e) {
                        return e.id === t.boardId
                    }
                    ))
                },
                categoryList: function() {
                    return this.board ? this.board.topics : []
                },
                categoryNotSet: function() {
                    return "$not-set" === this.categoryId
                },
                isCategoryWarning: function() {
                    return this.categoryNotSet && this.emptyWarnings.includes("category")
                },
                isBoardWarning: function() {
                    return !this.boardId && this.emptyWarnings.includes("board")
                },
                isTitleWarning: function() {
                    return !this.title && this.emptyWarnings.includes("title")
                },
                editMode: function() {
                    return !!this.post
                },
                writeTitle: function() {
                    return this.editMode ? this.$t("write-edit") : this.$t("write")
                }
            }),
            watch: {
                boardId: function() {
                    this.categoryId = ""
                }
            },
            created: function() {
                var t = this
                  , e = this.$route.params.board;
                if (e) {
                    var n = e.split("/");
                    if ("board" === n[1]) {
                        var a = this.$store.getters.getIdBySlug(n[2]);
                        this.boardList.map((function(t) {
                            return t.id
                        }
                        )).includes(a) && (this.boardId = a)
                    }
                }
                this.post && (this.boardId = this.post.parent_board.id,
                this.title = this.post.title,
                this.isSocial = this.post.is_content_social,
                this.isSexual = this.post.is_content_sexual,
                this.isAnonymous = 2 === this.post.name_type,
                this.loaded = !1,
                this.$nextTick((function() {
                    t.categoryId = t.post.parent_topic ? t.post.parent_topic.id : ""
                }
                )));
                var i = this.$route.query.board;
                i && (this.boardId = this.getIdBySlug(i))
            },
            mounted: function() {
                var t = this;
                return Object(u["a"])(p.a.mark((function e() {
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                if (!t.post) {
                                    e.next = 3;
                                    break
                                }
                                return e.next = 3,
                                t.$refs.attachments.init(t.post.attachments);
                            case 3:
                                t.loaded = !0;
                            case 4:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            methods: {
                attachFiles: function(t) {
                    this.$refs.attachments.handleUpload(t)
                },
                addAttachments: function(t) {
                    var e = this;
                    t.forEach((function(t) {
                        "image" === t.type && e.$refs.textEditor.addImageByFile(t)
                    }
                    ))
                },
                deleteAttachment: function(t) {
                    t.uploaded,
                    "image" === t.type && this.$refs.textEditor.removeImageByFile(t)
                },
                savePostByThePostWrite: function() {
                    if (this.loaded) {
                        var t = this.title
                          , e = this.boardId
                          , n = this.categoryId
                          , a = this.isSocial
                          , i = this.isSexual
                          , o = this.isAnonymous ? "ANONYMOUS" : "REGULAR";
                        o = 14 === this.boardId ? "REALNAME" : o,
                        this.$emit("save-post", {
                            title: t,
                            boardId: e,
                            categoryId: n,
                            isSocial: a,
                            isSexual: i,
                            nameType: o,
                            attachments: this.$refs.attachments.files
                        })
                    } else
                        this.$store.dispatch("dialog/toast", {
                            text: this.$t("uploading"),
                            type: "info"
                        })
                },
                openImageUpload: function() {
                    this.$refs.attachments.openImageUpload()
                },
                updateAttachments: function(t) {
                    this.$refs.textEditor.applyImageUpload(t)
                },
                getContent: function() {
                    return this.$refs.textEditor.getContent()
                }
            }
        }
          , Do = Lo
          , Uo = (n("8cb5"),
        n("a8dd"))
          , Mo = Object(y["a"])(Do, So, $o, !1, null, "77847f34", null);
        "function" === typeof Uo["default"] && Object(Uo["default"])(Mo);
        var qo = Mo.exports
          , zo = {
            name: "Write",
            components: {
                TheLayout: pn,
                ThePostWrite: qo
            },
            props: {
                postId: String
            },
            data: function() {
                return {
                    post: null,
                    saving: !1,
                    saved: !1,
                    emptyWarnings: []
                }
            },
            computed: {
                isEditing: function() {
                    return !!this.postId
                },
                postFetched: function() {
                    return !this.isEditing || this.isEditing && this.post
                }
            },
            beforeRouteEnter: function(t, e, n) {
                return Object(u["a"])(p.a.mark((function e() {
                    var a, i, o, s;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                if (a = t.params.postId,
                                a) {
                                    e.next = 5;
                                    break
                                }
                                n((function(t) {
                                    document.title = t.$t("document-title.write")
                                }
                                )),
                                e.next = 11;
                                break;
                            case 5:
                                return e.next = 7,
                                De([dt({
                                    postId: a,
                                    context: {
                                        override_hidden: !0
                                    }
                                })], "write-failed-fetch");
                            case 7:
                                i = e.sent,
                                o = Object(V["a"])(i, 1),
                                s = o[0],
                                n((function(t) {
                                    document.title = t.$t("document-title.revise"),
                                    t.post = s
                                }
                                ));
                            case 11:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            beforeRouteUpdate: function(t, e, n) {
                var a = this;
                return Object(u["a"])(p.a.mark((function e() {
                    var i, o, s, r, c;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                if (i = t.params.postId,
                                a.saved) {
                                    e.next = 7;
                                    break
                                }
                                return e.next = 4,
                                a.$store.dispatch("dialog/confirm", a.$t("before-unload"));
                            case 4:
                                if (o = e.sent,
                                o) {
                                    e.next = 7;
                                    break
                                }
                                return e.abrupt("return");
                            case 7:
                                if (i) {
                                    e.next = 12;
                                    break
                                }
                                document.title = a.$t("document-title.write"),
                                a.post = null,
                                e.next = 19;
                                break;
                            case 12:
                                return e.next = 14,
                                De([dt({
                                    postId: i
                                })], "write-failed-fetch");
                            case 14:
                                s = e.sent,
                                r = Object(V["a"])(s, 1),
                                c = r[0],
                                document.title = a.$t("document-title.revise"),
                                a.post = c;
                            case 19:
                                n();
                            case 20:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            beforeRouteLeave: function(t, e, n) {
                var a = this;
                return Object(u["a"])(p.a.mark((function t() {
                    var e;
                    return p.a.wrap((function(t) {
                        while (1)
                            switch (t.prev = t.next) {
                            case 0:
                                if (a.saved) {
                                    t.next = 6;
                                    break
                                }
                                return t.next = 3,
                                a.$store.dispatch("dialog/confirm", a.$t("before-unload"));
                            case 3:
                                return e = t.sent,
                                e && n(),
                                t.abrupt("return");
                            case 6:
                                n();
                            case 7:
                            case "end":
                                return t.stop()
                            }
                    }
                    ), t)
                }
                )))()
            },
            mounted: function() {
                var t = this;
                this.beforeUnloadHandler = function(e) {
                    e.returnValue = t.$t("before-unload")
                }
                ,
                window.addEventListener("beforeunload", this.beforeUnloadHandler)
            },
            destroyed: function() {
                window.removeEventListener("beforeunload", this.beforeUnloadHandler)
            },
            methods: {
                savePost: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a, i, o, s, r, c, l, u, d, m, f, h, _, b, v;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    if (a = t,
                                    i = a.title,
                                    o = a.boardId,
                                    s = a.categoryId,
                                    r = a.isSocial,
                                    c = a.isSexual,
                                    l = a.nameType,
                                    u = a.attachments,
                                    e.emptyWarnings = [],
                                    "" === i && e.emptyWarnings.push("title"),
                                    "<p></p>" === e.$refs.write.getContent() && e.emptyWarnings.push("content"),
                                    "" === o && e.emptyWarnings.push("board"),
                                    "$not-set" === s && e.emptyWarnings.push("category"),
                                    !(e.emptyWarnings.length > 0)) {
                                        n.next = 9;
                                        break
                                    }
                                    return e.$store.dispatch("dialog/toast", {
                                        type: "warning",
                                        text: e.$t("no-empty")
                                    }),
                                    n.abrupt("return");
                                case 9:
                                    if (14 !== o) {
                                        n.next = 15;
                                        break
                                    }
                                    return n.next = 12,
                                    e.$store.dispatch("dialog/confirm", e.$t("before-realname-write"));
                                case 12:
                                    if (d = n.sent,
                                    d) {
                                        n.next = 15;
                                        break
                                    }
                                    return n.abrupt("return");
                                case 15:
                                    if (e.saving = !0,
                                    m = u.filter((function(t) {
                                        return !t.uploaded
                                    }
                                    )),
                                    f = {},
                                    !u) {
                                        n.next = 31;
                                        break
                                    }
                                    return n.prev = 19,
                                    n.next = 22,
                                    At(m.map((function(t) {
                                        return t.file
                                    }
                                    )));
                                case 22:
                                    h = n.sent,
                                    m.forEach((function(t, e) {
                                        f[t.key] = h[e].data,
                                        t.uploaded = !0,
                                        t.key = h[e].data.id
                                    }
                                    )),
                                    n.next = 31;
                                    break;
                                case 26:
                                    return n.prev = 26,
                                    n.t0 = n["catch"](19),
                                    e.$store.dispatch("dialog/toast", {
                                        type: "error",
                                        text: e.$t("attachment-failed") + (n.t0.apierr ? "\n" + n.t0.apierr : "")
                                    }),
                                    e.saving = !1,
                                    n.abrupt("return");
                                case 31:
                                    if (_ = u.map((function(t) {
                                        return t.key
                                    }
                                    )),
                                    e.$refs.write.updateAttachments(f),
                                    b = e.$refs.write.getContent(),
                                    t = {
                                        title: i,
                                        content: b,
                                        attachments: _,
                                        parent_topic: s,
                                        is_content_sexual: c,
                                        is_content_social: r,
                                        name_type: l
                                    },
                                    n.prev = 35,
                                    e.isEditing) {
                                        n.next = 42;
                                        break
                                    }
                                    return n.next = 39,
                                    pt({
                                        newArticle: t,
                                        boardId: o
                                    });
                                case 39:
                                    v = n.sent,
                                    n.next = 45;
                                    break;
                                case 42:
                                    return n.next = 44,
                                    mt({
                                        newArticle: t,
                                        postId: e.postId
                                    });
                                case 44:
                                    v = n.sent;
                                case 45:
                                    n.next = 52;
                                    break;
                                case 47:
                                    return n.prev = 47,
                                    n.t1 = n["catch"](35),
                                    e.$store.dispatch("dialog/toast", {
                                        type: "error",
                                        text: (e.isEditing ? e.$t("create-failed") : e.$t("update-failed")) + (n.t1.apierr ? "\n" + n.t1.apierr : "")
                                    }),
                                    e.saving = !1,
                                    n.abrupt("return");
                                case 52:
                                    e.saving = !1,
                                    e.saved = !0,
                                    window.removeEventListener("beforeunload", e.beforeUnloadHandler),
                                    e.$router.push({
                                        name: "post",
                                        params: {
                                            postId: v.id
                                        }
                                    });
                                case 56:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n, null, [[19, 26], [35, 47]])
                    }
                    )))()
                }
            }
        }
          , Ko = zo
          , Wo = n("e0d3")
          , Ho = Object(y["a"])(Ko, Ao, Oo, !1, null, null, null);
        "function" === typeof Wo["default"] && Object(Wo["default"])(Ho);
        var Fo = Ho.exports
          , Vo = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("TheLayout", [n("TheNotifications", {
                attrs: {
                    notifications: t.notifications,
                    title: t.$t("title")
                }
            })], 1)
        }
          , Qo = []
          , Jo = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "the-notifications"
            }, [n("div", {
                staticClass: "read-all__wrapper"
            }, [n("h1", {
                attrs: {
                    id: "title"
                }
            }, [t._v(" " + t._s(t.title) + " ")]), n("button", {
                staticClass: "read-all",
                class: {
                    "read-all__on": t.isButtonOn
                },
                attrs: {
                    disabled: !t.isButtonOn
                },
                on: {
                    click: t.readAllAlarm
                }
            }, [n("i", {
                staticClass: "material-icons check-icon"
            }, [t._v("check_circle_outline")]), t._v(" " + t._s(t.$t("readAll")) + " ")])]), n("div", t._l(t.notifications.results, (function(t) {
                return n("Notification", {
                    key: t.id,
                    attrs: {
                        notification: t
                    }
                })
            }
            )), 1), n("ThePaginator", {
                attrs: {
                    "num-pages": t.notifications.num_pages,
                    "current-page": t.notifications.current,
                    "base-route-to": {
                        name: "notifications"
                    }
                }
            })], 1)
        }
          , Go = []
          , Yo = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("router-link", {
                staticClass: "noti",
                class: {
                    "is-read": t.isRead
                },
                attrs: {
                    to: {
                        name: "post",
                        params: {
                            postId: t.notification.related_article.id,
                            notiId: t.notification.id
                        },
                        query: {
                            from_view: "all"
                        }
                    }
                }
            }, [n("i", {
                staticClass: "noti__icon material-icons-outlined"
            }, [t._v(" " + t._s(t.isSubcomment ? "forum_outlined" : "chat_bubble_outline_outlined") + " ")]), n("div", {
                staticClass: "noti__container"
            }, [n("h3", {
                staticClass: "noti__title"
            }, [t._v(" " + t._s(t.$t(t.isSubcomment ? "comment-title" : "article-title")) + " ")]), n("p", {
                staticClass: "noti__content"
            }, [t._v(" " + t._s(t.notification.content) + " ")]), n("div", {
                staticClass: "noti__related"
            }, [n("div", {
                staticClass: "noti__subcomment-container"
            }, [n("div", [t._v(t._s(t.$t("article")) + ": [" + t._s(t.boardName) + "] " + t._s(t.relatedArticle))])]), t.isSubcomment ? n("div", [t._v(" " + t._s(t.$t("comment")) + ": " + t._s(t.relatedComment) + " ")]) : t._e()])]), n("p", {
                staticClass: "noti__time"
            }, [t._v(" " + t._s(t.timeago(t.notification.created_at, t.$i18n.locale)) + " ")])])
        }
          , Zo = []
          , Xo = a["a"].extend({
            name: "Notification",
            props: {
                notification: {
                    type: Object,
                    required: !0
                }
            },
            computed: {
                isRead: function() {
                    return this.notification.is_read
                },
                isSubcomment: function() {
                    return "comment_commented" === this.notification.type
                },
                relatedArticle: function() {
                    return this.notification.related_article.title
                },
                relatedComment: function() {
                    var t;
                    return null === (t = this.notification.related_comment) || void 0 === t ? void 0 : t.content
                },
                boardName: function() {
                    return this.$store.getters.getNameById(this.notification.related_article.parent_board, this.$i18n.locale)
                }
            },
            methods: {
                timeago: et
            }
        })
          , ts = Xo
          , es = (n("80f5"),
        n("c311"))
          , ns = Object(y["a"])(ts, Yo, Zo, !1, null, "006584b4", null);
        "function" === typeof es["default"] && Object(es["default"])(ns);
        var as = ns.exports
          , is = {
            name: "TheNotifications",
            components: {
                Notification: as,
                ThePaginator: Nn
            },
            props: {
                notifications: {
                    type: Object,
                    required: !0
                },
                title: String
            },
            data: function() {
                return {
                    isButtonClicked: !1
                }
            },
            computed: {
                isUnreadExist: function() {
                    var t;
                    return (null === (t = this.notifications.results) || void 0 === t ? void 0 : t.filter((function(t) {
                        return !1 === t.is_read
                    }
                    )).length) > 0
                },
                isButtonOn: function() {
                    return this.isUnreadExist && !this.isButtonClicked
                }
            },
            methods: {
                readAllAlarm: function() {
                    this.isButtonClicked = !0;
                    var t, e = Object(H["a"])(this.notifications.results);
                    try {
                        for (e.s(); !(t = e.n()).done; ) {
                            var n = t.value;
                            n.is_read = !0
                        }
                    } catch (a) {
                        e.e(a)
                    } finally {
                        e.f()
                    }
                    Bt()
                }
            }
        }
          , os = is
          , ss = (n("9b78"),
        n("9033"))
          , rs = Object(y["a"])(os, Jo, Go, !1, null, "8acd387e", null);
        "function" === typeof ss["default"] && Object(ss["default"])(rs);
        var cs = rs.exports
          , ls = {
            name: "Notifications",
            components: {
                TheLayout: pn,
                TheNotifications: cs
            },
            data: function() {
                return {
                    notifications: {}
                }
            },
            beforeRouteEnter: function(t, e, n) {
                return Object(u["a"])(p.a.mark((function e() {
                    var a, i, o, s;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return a = t.query,
                                e.next = 3,
                                De([Pt({
                                    query: a
                                })], "notifications-failed-fetch");
                            case 3:
                                i = e.sent,
                                o = Object(V["a"])(i, 1),
                                s = o[0],
                                n((function(t) {
                                    t.notifications = s,
                                    document.title = t.$t("document-title")
                                }
                                ));
                            case 7:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            beforeRouteUpdate: function(t, e, n) {
                var a = this;
                return Object(u["a"])(p.a.mark((function e() {
                    var i, o, s, r;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return i = t.query,
                                e.next = 3,
                                De([Pt({
                                    query: i
                                })], "notifications-failed-fetch");
                            case 3:
                                o = e.sent,
                                s = Object(V["a"])(o, 1),
                                r = s[0],
                                a.notifications = r,
                                n();
                            case 8:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            }
        }
          , us = ls
          , ds = n("d22a")
          , ps = Object(y["a"])(us, Vo, Qo, !1, null, null, null);
        "function" === typeof ds["default"] && Object(ds["default"])(ps);
        var ms = ps.exports
          , fs = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("TheLayout", {
                staticClass: "my-info",
                attrs: {
                    "is-column-layout": !1
                },
                scopedSlots: t._u([{
                    key: "aside-right",
                    fn: function() {
                        return [n("div", {
                            staticClass: "column is-one-quarter"
                        }, [n("div", {
                            staticClass: "boxes",
                            class: {
                                "boxes--mobile-open": t.mobileSettings
                            }
                        }, [n("div", {
                            staticClass: "mobile-header"
                        }, [n("a", {
                            staticClass: "mobile-header__back",
                            on: {
                                click: function(e) {
                                    t.mobileSettings = !1
                                }
                            }
                        }, [n("i", {
                            staticClass: "material-icons"
                        }, [t._v("chevron_left")])]), n("span", {
                            staticClass: "mobile-header__title"
                        }, [t._v(" " + t._s(t.$t("settings")) + " ")])]), n("div", {
                            staticClass: "box"
                        }, [n("div", {
                            staticClass: "redbox"
                        }), n("h1", {
                            staticClass: "box__title"
                        }, [t._v(" " + t._s(t.$t("ranking-title")) + " ")]), n("div", {
                            staticClass: "box__container"
                        }, [n("div", {
                            staticClass: "ranking"
                        }, [n("div", {
                            staticClass: "ranking__card"
                        }, [n("div", {
                            staticClass: "ranking__card--title"
                        }, [t._v(" " + t._s(t.$t("ranking-posts")) + " ")]), n("div", {
                            staticClass: "ranking__card--counts"
                        }, [t._v(" " + t._s(t.$t("ranking-posts-count", {
                            count: t.user.num_articles
                        })) + " ")])]), n("div", {
                            staticClass: "ranking__card"
                        }, [n("div", {
                            staticClass: "ranking__card--title"
                        }, [t._v(" " + t._s(t.$t("ranking-comments")) + " ")]), n("div", {
                            staticClass: "ranking__card--counts"
                        }, [t._v(" " + t._s(t.$t("ranking-comments-count", {
                            count: t.user.num_comments
                        })) + " ")])]), n("div", {
                            staticClass: "ranking__card"
                        }, [n("div", {
                            staticClass: "ranking__card--title"
                        }, [t._v(" " + t._s(t.$t("ranking-likes")) + " ")]), n("div", {
                            staticClass: "ranking__card--counts"
                        }, [t._v(" " + t._s(t.$t("ranking-likes-count", {
                            count: t.user.num_positive_votes
                        })) + " ")])])])])]), n("div", {
                            staticClass: "box"
                        }, [n("div", {
                            staticClass: "redbox"
                        }), n("h1", {
                            staticClass: "box__title"
                        }, [t._v(" " + t._s(t.$t("settings-title")) + " ")]), n("h2", {
                            staticClass: "box__subtitle"
                        }, [t._v(" " + t._s(t.$t("settings-subtitle")) + " ")]), n("div", {
                            staticClass: "box__container"
                        }, [n("div", {
                            staticClass: "settings"
                        }, [n("div", {
                            staticClass: "settings__container"
                        }, [n("span", {
                            staticClass: "label"
                        }, [t._v(t._s(t.$t("settings-sexual")))]), n("div", {
                            on: {
                                click: function(e) {
                                    return t.updateSetting("sexual")
                                }
                            }
                        }, [t.user.sexual ? n("i", {
                            staticClass: "material-icons toggle-on"
                        }, [t._v(" toggle_on ")]) : n("i", {
                            staticClass: "material-icons"
                        }, [t._v(" toggle_off ")])])]), n("div", {
                            staticClass: "settings__container"
                        }, [n("span", {
                            staticClass: "label"
                        }, [t._v(t._s(t.$t("settings-social")))]), n("div", {
                            on: {
                                click: function(e) {
                                    return t.updateSetting("social")
                                }
                            }
                        }, [t.user.social ? n("i", {
                            staticClass: "material-icons toggle-on"
                        }, [t._v(" toggle_on ")]) : n("i", {
                            staticClass: "material-icons"
                        }, [t._v(" toggle_off ")])])])])])]), n("div", {
                            staticClass: "box"
                        }, [n("div", {
                            staticClass: "redbox"
                        }), n("h1", {
                            staticClass: "box__title"
                        }, [t._v(" " + t._s(t.$t("blocked-title")) + " ")]), n("h2", {
                            staticClass: "box__subtitle",
                            domProps: {
                                innerHTML: t._s(t.$t("blocked-subtitle", {
                                    user: t.user.nickname
                                }))
                            }
                        }), n("div", {
                            staticClass: "box__container"
                        }, [t.blocks && t.blocks.results && t.blocks.results.length > 0 ? n("ul", {
                            staticClass: "blocked"
                        }, t._l(t.blocks.results, (function(e) {
                            return n("li", {
                                key: e.id
                            }, [n("div", {
                                staticClass: "blocked__user"
                            }, [n("img", {
                                staticClass: "blocked__user--image",
                                attrs: {
                                    src: e.user.profile.picture
                                }
                            }), n("span", {
                                staticClass: "blocked__user--nickname"
                            }, [t._v(" " + t._s(e.user.profile.nickname) + " ")]), n("a", {
                                staticClass: "blocked__user--remove",
                                on: {
                                    click: function(n) {
                                        return t.deleteBlockedUser(e.id)
                                    }
                                }
                            }, [n("i", {
                                staticClass: "material-icons",
                                staticStyle: {
                                    "font-size": "1.3rem"
                                }
                            }, [t._v("close")])])])])
                        }
                        )), 0) : n("div", {
                            staticClass: "blocked-empty"
                        }, [t._v(" " + t._s(t.$t("blocked-empty")) + " ")])])])])])]
                    },
                    proxy: !0
                }])
            }, [n("div", {
                staticClass: "column "
            }, [n("div", {
                staticClass: "profile-box"
            }, [t.isNicknameEditable ? t._e() : n("button", {
                staticClass: "button setting-button",
                on: {
                    click: function(e) {
                        t.mobileSettings = !t.mobileSettings
                    }
                }
            }, [t._v(" " + t._s(t.$t("my-info")) + " ")]), n("div", {
                staticClass: "profile-container",
                style: {
                    backgroundColor: t.user.pictureSrc ? "white" : "grey"
                }
            }, [t.user.pictureSrc ? n("img", {
                staticClass: "profile-container__image",
                attrs: {
                    src: t.user.pictureSrc,
                    alt: "profile image"
                }
            }) : t._e(), n("label", [n("input", {
                staticStyle: {
                    display: "none"
                },
                attrs: {
                    type: "file"
                },
                on: {
                    change: t.pictureHandler
                }
            }), n("a", {
                staticClass: "profile-container__button"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("camera_alt")])])])]), n("div", {
                staticClass: "nickname-container"
            }, [t.isNicknameEditable ? n("div", {
                staticClass: "nickname__direction"
            }, [n("input", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.newNickname,
                    expression: "newNickname"
                }],
                staticClass: "input nickname nickname__input",
                domProps: {
                    value: t.newNickname
                },
                on: {
                    input: function(e) {
                        e.target.composing || (t.newNickname = e.target.value)
                    }
                }
            }), n("div", {
                staticClass: "nickname__buttons"
            }, [n("button", {
                staticClass: "button",
                class: {
                    "is-loading": t.updating
                },
                staticStyle: {
                    "margin-left": "0.8rem",
                    color: "var(--theme-400)"
                },
                on: {
                    click: function(e) {
                        return t.toggleNicknameInput(!0)
                    }
                }
            }, [t._v(" " + t._s(t.$t("save")) + " ")]), n("button", {
                staticClass: "button",
                staticStyle: {
                    "margin-left": "0.8rem"
                },
                on: {
                    click: function(e) {
                        return t.toggleNicknameInput(!1)
                    }
                }
            }, [t._v(" " + t._s(t.$t("cancel")) + " ")])])]) : n("div", {
                staticClass: "row"
            }, [n("h1", {
                staticClass: "nickname"
            }, [t._v(" " + t._s(t.user.nickname) + " ")]), n("a", {
                staticStyle: {
                    "margin-left": "0.5rem"
                },
                on: {
                    click: t.toggleNicknameInput
                }
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("create")])])]), n("h2", {
                staticClass: "email"
            }, [t._v(" " + t._s(t.user.email ? t.user.email : t.$t("empty-email")) + " ")])])]), n("div", {
                staticClass: "tabs",
                staticStyle: {
                    margin: "0 0 0 -1px"
                }
            }, [n("ul", [n("li", {
                class: {
                    "is-active": "recent" !== t.$route.query.board && "archive" !== t.$route.query.board
                }
            }, [n("router-link", {
                attrs: {
                    to: {
                        query: {
                            board: "my"
                        }
                    }
                }
            }, [t._v(" " + t._s(t.$t("board-my")) + " ")])], 1), n("li", {
                class: {
                    "is-active": "recent" === t.$route.query.board
                }
            }, [n("router-link", {
                attrs: {
                    to: {
                        query: {
                            board: "recent"
                        }
                    }
                }
            }, [t._v(" " + t._s(t.$t("board-recent")) + " ")])], 1), n("li", {
                class: {
                    "is-active": "archive" === t.$route.query.board
                }
            }, [n("router-link", {
                attrs: {
                    to: {
                        query: {
                            board: "archive"
                        }
                    }
                }
            }, [t._v(" " + t._s(t.$t("board-archive")) + " ")])], 1)]), n("SearchBar", {
                staticClass: "desktop-search is-hidden-touch",
                attrs: {
                    searchable: "",
                    long: ""
                }
            })], 1), n("hr", {
                staticClass: "tabs-divider"
            }), t.posts ? n("TheBoard", {
                attrs: {
                    title: t.boardTitle,
                    board: t.posts,
                    "from-query": t.fromQuery,
                    simplify: ""
                }
            }) : t._e()], 1)])
        }
          , hs = []
          , _s = n("ade3")
          , bs = function(t) {
            var e = t.board
              , n = Object(U["a"])(Object(U["a"])({}, t), {}, {
                board: void 0
            });
            switch (e) {
            case "recent":
                return Vt(t);
            case "archive":
                return Ft(t);
            default:
                return n.username = Xt.getters.userId,
                Wt(n)
            }
        }
          , vs = {
            name: "MyInfo",
            components: {
                SearchBar: $n,
                TheLayout: pn,
                TheBoard: ra
            },
            data: function() {
                return {
                    user: {
                        nickname: null,
                        email: null,
                        picture: null,
                        pictureSrc: "",
                        sexual: null,
                        social: null,
                        num_articles: null,
                        num_comments: null,
                        num_positive_votes: null
                    },
                    posts: null,
                    blocks: null,
                    updating: !1,
                    tabIndex: 0,
                    isNicknameEditable: !1,
                    newNickname: null,
                    mobileSettings: !1
                }
            },
            computed: Object(U["a"])(Object(U["a"])(Object(U["a"])({}, Object(M["d"])(["recentPosts", "archivedPosts"])), Object(M["c"])(["userId"])), {}, {
                fromQuery: function() {
                    switch (this.$route.query.board) {
                    case "recent":
                        return {
                            from_view: "recent"
                        };
                    case "archive":
                        return {
                            from_view: "scrap"
                        };
                    default:
                        return {
                            from_view: "user",
                            created_by: this.userId
                        }
                    }
                },
                boardTitle: function() {
                    if (!this.$route.query.query)
                        return "";
                    switch (this.$route.query.board) {
                    case "recent":
                        return this.$t("board-recent");
                    case "archive":
                        return this.$t("board-archive");
                    default:
                        return this.$t("board-my")
                    }
                },
                myRanking: function() {
                    return "👶아기 넙죽이"
                }
            }),
            beforeRouteEnter: function(t, e, n) {
                return Object(u["a"])(p.a.mark((function e() {
                    var a, i, o, s, r, c, l, u, d, m, f;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return a = t.query,
                                e.next = 3,
                                De([Xt.dispatch("fetchMe"), bs(a), Lt()], "myinfo-failed-fetch");
                            case 3:
                                i = e.sent,
                                o = Object(V["a"])(i, 3),
                                s = o[1],
                                r = o[2],
                                c = Xt.getters,
                                l = c.userNickname,
                                u = c.userEmail,
                                d = c.userPicture,
                                m = c.userConfig,
                                f = c.userActivity,
                                n((function(t) {
                                    t.user = {
                                        nickname: l,
                                        email: u,
                                        pictureSrc: d,
                                        sexual: m.sexual,
                                        social: m.social,
                                        num_articles: f.articles,
                                        num_comments: f.comments,
                                        num_positive_votes: f.positiveVotes
                                    },
                                    t.posts = s,
                                    t.blocks = r,
                                    document.title = t.$t("document-title")
                                }
                                ));
                            case 9:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            beforeRouteUpdate: function(t, e, n) {
                var a = this;
                return Object(u["a"])(p.a.mark((function e() {
                    var i, o, s, r;
                    return p.a.wrap((function(e) {
                        while (1)
                            switch (e.prev = e.next) {
                            case 0:
                                return i = t.query,
                                e.next = 3,
                                De([bs(i)], "myinfo-failed-fetch");
                            case 3:
                                o = e.sent,
                                s = Object(V["a"])(o, 1),
                                r = s[0],
                                a.posts = r,
                                n();
                            case 8:
                            case "end":
                                return e.stop()
                            }
                    }
                    ), e)
                }
                )))()
            },
            methods: {
                changeTabIndex: function(t) {
                    this.tabIndex = t
                },
                updateSettings: function() {
                    var t = arguments
                      , e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    return a = !(t.length > 0 && void 0 !== t[0]) || t[0],
                                    e.updating = a,
                                    n.prev = 2,
                                    n.next = 5,
                                    Tt(e.userId, {
                                        nickname: e.newNickname ? e.newNickname : e.user.nickname,
                                        email: e.user.email,
                                        picture: e.user.picture,
                                        sexual: e.user.sexual,
                                        social: e.user.social
                                    }).then((function(t) {
                                        Xt.commit("setUserProfile", t.data),
                                        e.$store.dispatch("dialog/toast", {
                                            text: e.$t("success"),
                                            type: "confirm"
                                        }),
                                        e.newNickname && (e.user.nickname = e.newNickname)
                                    }
                                    ));
                                case 5:
                                    n.next = 10;
                                    break;
                                case 7:
                                    n.prev = 7,
                                    n.t0 = n["catch"](2),
                                    e.$store.dispatch("dialog/toast", {
                                        text: e.$t("setting-change-failed") + (n.t0.apierr ? "\n" + n.t0.apierr : ""),
                                        type: "error"
                                    });
                                case 10:
                                    e.updating = !1;
                                case 11:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n, null, [[2, 7]])
                    }
                    )))()
                },
                updateSetting: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a, i;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    if ("sexual" === t || "social" === t) {
                                        n.next = 2;
                                        break
                                    }
                                    return n.abrupt("return");
                                case 2:
                                    return n.prev = 2,
                                    n.next = 5,
                                    Tt(e.userId, Object(U["a"])(Object(U["a"])({}, e.user), {}, Object(_s["a"])({}, t, !e.user[t])));
                                case 5:
                                    a = n.sent,
                                    i = a.data,
                                    Xt.commit("setUserProfile", i),
                                    e.user[t] = !e.user[t],
                                    e.$store.dispatch("dialog/toast", {
                                        text: e.$t("success"),
                                        type: "confirm"
                                    }),
                                    n.next = 15;
                                    break;
                                case 12:
                                    n.prev = 12,
                                    n.t0 = n["catch"](2),
                                    e.$store.dispatch("dialog/toast", {
                                        text: e.$t("setting-change-failed") + (n.t0.apierr ? "\n" + n.t0.apierr : ""),
                                        type: "error"
                                    });
                                case 15:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n, null, [[2, 12]])
                    }
                    )))()
                },
                pictureHandler: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a, i, o, s;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    return a = Object(V["a"])(t.target.files, 1),
                                    i = a[0],
                                    s = new FileReader,
                                    s.onload = function(t) {
                                        o = t.target.result
                                    }
                                    ,
                                    s.readAsDataURL(i),
                                    e.user.picture = i,
                                    n.next = 7,
                                    e.updateSettings(!1);
                                case 7:
                                    e.user.pictureSrc = o;
                                case 8:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n)
                    }
                    )))()
                },
                toggleNicknameInput: function() {
                    var t = arguments
                      , e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    if (a = t.length > 0 && void 0 !== t[0] && t[0],
                                    e.isNicknameEditable) {
                                        n.next = 6;
                                        break
                                    }
                                    e.newNickname = e.user.nickname,
                                    e.isNicknameEditable = !0,
                                    n.next = 10;
                                    break;
                                case 6:
                                    if (!a || e.user.nickname === e.newNickname) {
                                        n.next = 9;
                                        break
                                    }
                                    return n.next = 9,
                                    e.updateSettings();
                                case 9:
                                    e.isNicknameEditable = !1;
                                case 10:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n)
                    }
                    )))()
                },
                deleteBlockedUser: function(t) {
                    var e = this;
                    return Object(u["a"])(p.a.mark((function n() {
                        var a, i;
                        return p.a.wrap((function(n) {
                            while (1)
                                switch (n.prev = n.next) {
                                case 0:
                                    return n.prev = 0,
                                    n.next = 3,
                                    Dt(t);
                                case 3:
                                    if (a = n.sent,
                                    i = a.status,
                                    403 !== i) {
                                        n.next = 7;
                                        break
                                    }
                                    return n.abrupt("return", e.$store.dispatch("dialog/toast", e.$t("block-rate-limit")));
                                case 7:
                                    return n.next = 9,
                                    Lt();
                                case 9:
                                    e.blocks = n.sent,
                                    n.next = 15;
                                    break;
                                case 12:
                                    n.prev = 12,
                                    n.t0 = n["catch"](0),
                                    e.$store.dispatch("dialog/toast", {
                                        text: e.$t("unblock-failed") + (n.t0.apierr ? "\n" + n.t0.apierr : ""),
                                        type: "error"
                                    });
                                case 15:
                                case "end":
                                    return n.stop()
                                }
                        }
                        ), n, null, [[0, 12]])
                    }
                    )))()
                }
            }
        }
          , gs = vs
          , ys = (n("c8f3"),
        n("85e4"))
          , ks = Object(y["a"])(gs, fs, hs, !1, null, "1f5c659e", null);
        "function" === typeof ys["default"] && Object(ys["default"])(ks);
        var Cs = ks.exports
          , ws = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("TheLayout", {
                staticClass: "home"
            }, [n("div", {
                staticClass: "home__searchbar"
            }, [n("TheHomeSearchbar")], 1), n("div", {
                staticClass: "home__organizations"
            }, [n("TheOrganizations")], 1), n("div", {
                staticClass: "columns is-multiline"
            }, [n("SmallBoard", {
                staticClass: "home__board column is-4",
                attrs: {
                    listitems: t.dailyBests,
                    detail: ""
                }
            }, [t._v(" " + t._s(t.$t("today-best")) + " ")]), n("SmallBoard", {
                staticClass: "home__board column is-4",
                attrs: {
                    listitems: t.weeklyBests,
                    detail: ""
                }
            }, [t._v(" " + t._s(t.$t("weekly-best")) + " ")]), t.notice ? n("SmallBoard", {
                staticClass: "home__board column is-4",
                attrs: {
                    listitems: t.notice,
                    href: {
                        name: "board",
                        params: {
                            boardSlug: "ara-notice"
                        }
                    },
                    detail: ""
                }
            }, [t._v(" " + t._s(t.$t("ara-notice")) + " ")]) : t._e()], 1)])
        }
          , xs = []
          , As = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "searchbar"
            }, [n("h2", {
                staticClass: "searchbar__landing"
            }, [n("i18n", {
                attrs: {
                    path: "landing.text"
                },
                scopedSlots: t._u([{
                    key: "ara",
                    fn: function() {
                        return [n("span", {
                            staticClass: "searchbar__landing--bold"
                        }, [t._v(t._s(t.$t("landing.ara")))])]
                    },
                    proxy: !0
                }, {
                    key: "accurate",
                    fn: function() {
                        return [n("span", {
                            staticClass: "searchbar__landing--highlight"
                        }, [t._v(t._s(t.$t("landing.accurate")))])]
                    },
                    proxy: !0
                }, {
                    key: "fast",
                    fn: function() {
                        return [n("span", {
                            staticClass: "searchbar__landing--highlight"
                        }, [t._v(t._s(t.$t("landing.fast")))])]
                    },
                    proxy: !0
                }])
            })], 1), n("form", {
                staticClass: "searchbar__search field",
                attrs: {
                    action: "board"
                },
                on: {
                    submit: function(e) {
                        return e.preventDefault(),
                        t.search.apply(null, arguments)
                    }
                }
            }, [n("p", {
                staticClass: "control has-icons-left"
            }, [n("input", {
                directives: [{
                    name: "model",
                    rawName: "v-model",
                    value: t.query,
                    expression: "query"
                }],
                staticClass: "input is-large",
                attrs: {
                    type: "text",
                    name: "query"
                },
                domProps: {
                    value: t.query
                },
                on: {
                    input: function(e) {
                        e.target.composing || (t.query = e.target.value)
                    }
                }
            }), t._m(0)])]), n("div", {
                staticClass: "keywords"
            }, [n("span", {
                staticClass: "keywords__description"
            }, [t._v(" " + t._s(t.$t("keyword")) + " ")]), n("div", {
                staticClass: "keywords__list"
            }, t._l(t.keywords, (function(e) {
                return n("router-link", {
                    key: e.key,
                    staticClass: "keywords__keyword",
                    attrs: {
                        to: {
                            name: "board",
                            query: {
                                query: e[t.$i18n.locale + "_name"]
                            }
                        }
                    }
                }, [t._v(" " + t._s(e[t.$i18n.locale + "_name"]) + " ")])
            }
            )), 1)])])
        }
          , Os = [function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("button", {
                staticClass: "icon is-small is-left",
                attrs: {
                    type: "submit"
                }
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("search")])])
        }
        ]
          , Ss = [{
            key: "students-working",
            ko_name: "근로학생",
            en_name: "Students Working"
        }, {
            key: "lecture-review",
            ko_name: "강의평가",
            en_name: "Lecture Review"
        }, {
            key: "enrolment",
            ko_name: "수강신청",
            en_name: "Enrolment"
        }, {
            key: "season-term",
            ko_name: "계절학기",
            en_name: "Season Term"
        }, {
            key: "grade-posting-period",
            ko_name: "성적게시기간",
            en_name: "Grade Posting Period"
        }, {
            key: "tuition-payment",
            ko_name: "등록금 납부",
            en_name: "Tuition Payment"
        }, {
            key: "graduation-requirements",
            ko_name: "졸업요건",
            en_name: "Graduation Reqs"
        }]
          , $s = {
            name: "TheHomeSearchbar",
            data: function() {
                return {
                    query: "",
                    keywords: Ss
                }
            },
            methods: {
                search: function() {
                    this.$router.push({
                        name: "board",
                        query: {
                            query: this.query
                        }
                    })
                }
            }
        }
          , js = $s
          , Ts = (n("f87e"),
        n("c751"))
          , Es = Object(y["a"])(js, As, Os, !1, null, "611ab7d6", null);
        "function" === typeof Ts["default"] && Object(Ts["default"])(Es);
        var Is = Es.exports
          , Ps = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", [n("splide", {
                key: t.$i18n.locale,
                staticClass: "the-organizations organizations-padding",
                attrs: {
                    options: t.primaryOptions
                }
            }, t._l(t.organizations, (function(e) {
                return n("splide-slide", t._b({
                    key: e.id
                }, "splide-slide", e, !1), [n("OrganizationCard", t._b({
                    key: e.id
                }, "OrganizationCard", e, !1))], 1)
            }
            )), 1), n("OrganizationCard", {
                staticClass: "is-invisible organizations-padding",
                attrs: {
                    id: "",
                    name: "portal-notice"
                }
            })], 1)
        }
          , Ns = []
          , Rs = function() {
            var t = this
              , e = t.$createElement
              , a = t._self._c || e;
            return a("div", {
                staticClass: "organization-card-wrap"
            }, [a("router-link", {
                staticClass: "organization-card",
                style: {
                    "background-color": t.backgroundColor
                },
                attrs: {
                    to: t.generateHref
                }
            }, [t.icon ? a("i", {
                staticClass: "logo logo--icon material-icons"
            }, [t._v(t._s(t.icon))]) : t.id ? a("img", {
                staticClass: "logo",
                attrs: {
                    src: n("f0ef")("./Logo" + t.id + ".png")
                }
            }) : t._e()]), a("span", {
                staticClass: "name"
            }, [t._v(t._s(t.$t(t.name)))])], 1)
        }
          , Bs = []
          , Ls = {
            name: "OrganizationCard",
            props: {
                name: {
                    type: String,
                    required: !0
                },
                id: {
                    type: String,
                    required: !0
                },
                backgroundColor: {
                    type: String,
                    default: "#fdf0f0"
                },
                icon: String,
                slug: String
            },
            computed: {
                generateHref: function() {
                    switch (this.id) {
                    case "KAIST":
                        return {
                            name: "board",
                            params: {
                                boardSlug: "portal-notice"
                            }
                        };
                    case "all":
                        return {
                            name: "board"
                        };
                    default:
                        return this.generateOrganizationHref()
                    }
                }
            },
            methods: {
                generateOrganizationHref: function() {
                    return this.slug ? {
                        name: "board",
                        params: {
                            boardSlug: "students-group"
                        },
                        query: {
                            topic: this.slug
                        }
                    } : ""
                }
            }
        }
          , Ds = Ls
          , Us = (n("d4fc"),
        n("98ca"))
          , Ms = Object(y["a"])(Ds, Rs, Bs, !1, null, "6833c474", null);
        "function" === typeof Us["default"] && Object(Us["default"])(Ms);
        var qs = Ms.exports
          , zs = n("5e2b")
          , Ks = (n("fd48"),
        {
            name: "TheOrganizations",
            components: {
                OrganizationCard: qs,
                Splide: zs["a"],
                SplideSlide: zs["b"]
            },
            data: function() {
                return {
                    organizations: [{
                        name: "portal-notice",
                        id: "KAIST",
                        backgroundColor: "#dbdbdb"
                    }, {
                        name: "all-posts",
                        id: "all",
                        icon: "dashboard",
                        backgroundColor: "#ed3a3a"
                    }, {
                        name: "clubs-union",
                        id: "UA",
                        slug: "clubs-union"
                    }, {
                        name: "dormitory-council",
                        id: "GSDC",
                        slug: "dorm-council"
                    }, {
                        name: "welfare-committee",
                        id: "SWF",
                        slug: "welfare-cmte"
                    }, {
                        name: "undergraduate-association",
                        id: "SA",
                        slug: "undergrad-assoc"
                    }, {
                        name: "graduate-association",
                        id: "GSA",
                        slug: "grad-assoc"
                    }, {
                        name: "freshman-council",
                        id: "NSA",
                        slug: "freshman-council"
                    }, {
                        name: "kcoop",
                        id: "KCOOP",
                        slug: "kcoop"
                    }],
                    primaryOptions: {
                        type: "loop",
                        perPage: 9,
                        interval: 3e3,
                        perMove: 1,
                        gap: "1rem",
                        arrows: !0,
                        autoplay: !0,
                        pagination: !1,
                        breakpoints: {},
                        classes: {
                            arrow: "splide__arrow custom-arrow"
                        }
                    }
                }
            },
            created: function() {
                for (var t = 0, e = [[1470, 8], [1280, 7], [1e3, 6], [767, 5], [590, 4], [480, 4], [435, 3]]; t < e.length; t++) {
                    var n = e[t];
                    this.primaryOptions.breakpoints[n[0].toString()] = {
                        perPage: n[1],
                        padding: {
                            left: 0,
                            right: n[0] <= 480 ? 40 : 0
                        }
                    }
                }
            }
        })
          , Ws = Ks
          , Hs = (n("5867"),
        Object(y["a"])(Ws, Ps, Ns, !1, null, null, null))
          , Fs = Hs.exports
          , Vs = {
            name: "Home",
            components: {
                SmallBoard: _a,
                TheHomeSearchbar: Is,
                TheOrganizations: Fs,
                TheLayout: pn
            },
            data: function() {
                return {
                    home: {},
                    notice: []
                }
            },
            computed: {
                dailyBests: function() {
                    return this.home.daily_bests ? this.home.daily_bests : []
                },
                weeklyBests: function() {
                    return this.home.weekly_bests ? this.home.weekly_bests : []
                }
            },
            beforeRouteEnter: function(t, e, n) {
                return Object(u["a"])(p.a.mark((function t() {
                    var e, a, i, o, s, r;
                    return p.a.wrap((function(t) {
                        while (1)
                            switch (t.prev = t.next) {
                            case 0:
                                return e = [ut()],
                                a = Xt.getters.getIdBySlug("ara-notice"),
                                a && e.push(Wt({
                                    boardId: a,
                                    pageSize: 5
                                })),
                                t.next = 5,
                                De(e, "home-failed-fetch");
                            case 5:
                                i = t.sent,
                                o = Object(V["a"])(i, 2),
                                s = o[0],
                                r = o[1],
                                n((function(t) {
                                    t.home = s,
                                    t.notice = null === r || void 0 === r ? void 0 : r.results,
                                    document.title = t.$t("document-title")
                                }
                                ));
                            case 10:
                            case "end":
                                return t.stop()
                            }
                    }
                    ), t)
                }
                )))()
            }
        }
          , Qs = Vs
          , Js = (n("af80"),
        n("4bd9"))
          , Gs = Object(y["a"])(Qs, ws, xs, !1, null, "728e9f00", null);
        "function" === typeof Js["default"] && Object(Js["default"])(Gs);
        var Ys = Gs.exports
          , Zs = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", [n("div", {
                staticClass: "not-found-container"
            }, [n("div", {
                staticClass: "not-found-404"
            }, [t._v(" 404 ")]), n("div", {
                staticClass: "not-found-text"
            }, [t._v(" " + t._s(t.$t("page-not-found")) + " ")]), n("router-link", {
                attrs: {
                    to: {
                        name: "home"
                    }
                }
            }, [n("div", {
                staticClass: "not-found-go-to-home"
            }, [t._v(" " + t._s(t.$t("go-home")) + " ")])])], 1)])
        }
          , Xs = []
          , tr = {
            name: "NotFound",
            beforeRouteEnter: function(t, e, n) {
                n((function(t) {
                    document.title = t.$t("document-title")
                }
                ))
            }
        }
          , er = tr
          , nr = (n("6fb9"),
        n("ba1a"))
          , ar = Object(y["a"])(er, Zs, Xs, !1, null, null, null);
        "function" === typeof nr["default"] && Object(nr["default"])(ar);
        var ir = ar.exports
          , or = function() {
            var t = this
              , e = t.$createElement
              , a = t._self._c || e;
            return a("div", {
                staticClass: "parent"
            }, [a("div", {
                staticClass: "landing"
            }, [a("a", {
                staticClass: "landing__lang",
                attrs: {
                    id: "toggle-language"
                },
                on: {
                    click: t.changeLocale
                }
            }, [t._m(0)]), a("div", {
                staticClass: "landing__internal"
            }, [t.helpPopup ? t._e() : a("div", [a("img", {
                staticClass: "landing__logo",
                attrs: {
                    src: n("fbee")
                }
            }), a("h3", {
                staticClass: "landing__title"
            }, [t._v(" " + t._s(t.$t("title")) + " ")]), a("div", {
                staticClass: "landing-section landing-section--relaxed"
            }, [a("p", [t._v(t._s(t.$t("from-oct")))]), a("p", [t._v(" " + t._s(t.$t("notice")) + " "), a("span", {
                staticClass: "red"
            }, [t._v(t._s(t.$t("highlight")))]), t._v(" " + t._s(t.$t("let-access")) + " ")])]), t._l(t.sections, (function(e, n) {
                return a("div", {
                    key: n,
                    staticClass: "landing-section"
                }, [a("h4", {
                    staticClass: "landing-section__title"
                }, [t._v(" " + t._s(e.title) + " ")]), t._l(e.contents, (function(e, i) {
                    return a("div", {
                        key: i,
                        staticClass: "landing-section__contents"
                    }, [a("span", {
                        staticClass: "check red"
                    }, [t._v("✓")]), a("i18n", {
                        attrs: {
                            path: "sections." + n + ".contents." + i + ".text"
                        },
                        scopedSlots: t._u([e.link ? {
                            key: "link",
                            fn: function() {
                                return [a("a", {
                                    staticClass: "landing-section__link",
                                    attrs: {
                                        href: e.link
                                    }
                                }, [t._v(" " + t._s(e["link-text"]) + " ")])]
                            },
                            proxy: !0
                        } : null], null, !0)
                    })], 1)
                }
                ))], 2)
            }
            )), a("div", {
                staticClass: "landing-section landing-section--relaxed"
            }, [a("p", [t._v(t._s(t.$t("more-info")))]), a("p", [t._v(t._s(t.$t("start-with")))])]), a("div", {
                staticClass: "landing__buttons"
            }, [a("router-link", {
                staticClass: "landing__button",
                attrs: {
                    to: {
                        name: "board",
                        params: {
                            boardSlug: "ara-notice"
                        }
                    }
                }
            }, [a("h4", [a("span", {
                staticClass: "red"
            }, [t._v(t._s(t.$t("new-ara")))]), t._v(" " + t._s(t.$t("new-ara-guide-name")) + " ")]), a("p", [t._v(t._s(t.$t("new-ara-guide-exp")))]), a("i", {
                staticClass: "material-icons"
            }, [t._v("chevron_right")])]), a("router-link", {
                staticClass: "landing__button",
                attrs: {
                    to: {
                        name: "home"
                    }
                }
            }, [a("h4", [a("span", {
                staticClass: "red"
            }, [t._v(t._s(t.$t("new-ara")))]), t._v(" " + t._s(t.$t("new-ara-link")) + " ")]), a("i", {
                staticClass: "material-icons"
            }, [t._v("chevron_right")])]), a("a", {
                staticClass: "landing__button",
                attrs: {
                    href: "https://ara.kaist.ac.kr"
                }
            }, [a("h4", [t._v(t._s(t.$t("old-ara-link")))]), a("i", {
                staticClass: "material-icons"
            }, [t._v("chevron_right")])])], 1)], 2), t._m(1)])])])
        }
          , sr = [function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("span", {
                staticClass: "icon"
            }, [n("i", {
                staticClass: "material-icons"
            }, [t._v("language")])])
        }
        , function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", {
                staticClass: "landing__contact"
            }, [n("p", [t._v("Contact")]), n("p", [t._v("new-ara@sparcs.org")])])
        }
        ]
          , rr = {
            name: "RenewalLandingPage",
            data: function() {
                return {
                    helpPopup: !1
                }
            },
            computed: {
                sections: function() {
                    return this.$i18n.messages[this.$i18n.locale].sections
                }
            },
            methods: {
                changeLocale: _
            }
        }
          , cr = rr
          , lr = (n("157a"),
        n("da4e"))
          , ur = Object(y["a"])(cr, or, sr, !1, null, "53e2d2dc", null);
        "function" === typeof lr["default"] && Object(lr["default"])(ur);
        var dr = ur.exports
          , pr = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("TheLayout", [n("p", {
                staticClass: "header side"
            }, [t._v(" Project ")]), n("div", {
                staticClass: "the-makers projects"
            }, t._l(t.projects, (function(e, a) {
                return n("MakersCard", {
                    key: e.name,
                    attrs: {
                        title: t.projectName(e),
                        subtitle: e.period,
                        active: t.selected === a,
                        launched: e.launched,
                        "is-project": ""
                    },
                    nativeOn: {
                        click: function(e) {
                            return t.projectClicked(a)
                        }
                    }
                })
            }
            )), 1), t.projects[t.selected].description ? n("div", {
                staticClass: "description-wrapper"
            }, [n("p", {
                staticClass: "header side"
            }, [t._v(" Description ")]), n("div", {
                staticClass: "description side"
            }, [n("p", [t._v(t._s(t.projects[t.selected].description))])])]) : t._e(), n("p", {
                staticClass: "header side"
            }, [t._v(" Member ")]), n("div", {
                staticClass: "the-makers members"
            }, [t._l(t.positions, (function(e) {
                return t._l(t.projects[t.selected].members[e], (function(a) {
                    return n("MakersCard", {
                        key: Array.isArray(a) ? a[0] : a,
                        attrs: {
                            title: t.memberName(a),
                            subtitle: t.memberNickname(a),
                            position: t.memberPosition(a, e)
                        }
                    })
                }
                ))
            }
            ))], 2)])
        }
          , mr = []
          , fr = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return t.isProject ? n("div", {
                staticClass: "project shadow-before",
                class: {
                    active: t.active
                }
            }, [n("span", {
                staticClass: "project__title"
            }, [t._v(t._s(t.title))]), n("span", {
                staticClass: "project__subtitle"
            }, [t._v(t._s(t.subtitle))]), t.launched ? n("span", {
                staticClass: "project__launched"
            }, [t._v(" launched at " + t._s(t.launched) + " ")]) : t._e()]) : n("div", {
                staticClass: "member shadow-before"
            }, [n("div", {
                staticClass: "text-container"
            }, [n("span", {
                staticClass: "member__title"
            }, [t._v(t._s(t.title))]), n("div", {
                staticClass: "sub-container"
            }, [t._m(0), n("span", {
                staticClass: "member__subtitle"
            }, [t._v(t._s(t.subtitle))])])]), n("span", {
                staticClass: "member__position"
            }, [t._v(t._s(t.position))])])
        }
          , hr = [function() {
            var t = this
              , e = t.$createElement
              , a = t._self._c || e;
            return a("div", {
                staticClass: "img-container"
            }, [a("img", {
                attrs: {
                    src: n("faeb"),
                    alt: "Sparcs Logo"
                }
            })])
        }
        ]
          , _r = {
            name: "MakersCard",
            props: {
                title: {
                    type: String,
                    required: !0
                },
                subtitle: {
                    type: String,
                    required: !0
                },
                position: String,
                active: Boolean,
                launched: String,
                isProject: Boolean
            }
        }
          , br = _r
          , vr = (n("d091"),
        Object(y["a"])(br, fr, hr, !1, null, "a7b71fe6", null))
          , gr = vr.exports
          , yr = {
            SO: "SysOp",
            PM: "Project Manager",
            DS: "Designer",
            DV: "Developer"
        }
          , kr = [{
            name: "SPARCS BBS",
            period: "1991~1998",
            launched: "1991",
            description: "1991년에 창립된 SPARCS가 가장 먼저 선보였던 아라입니다.\n      Eagle BBS (Pirite BBS) 기반으로 개발된 아라로, 우리나라에서 두번째로 생긴\n      Internet에 연결된 BBS (Bulletin Board System) 서비스입니다. 이때부터 아라는\n      계속해서 리뉴얼되어 왔으며, 현존하는 BBS 서비스 중에서는 가장 오래되었습니다.",
            members: {
                SO: ["cdpark:박종대"]
            }
        }, {
            name: "NeoAra",
            period: "1998~2006",
            launched: "1998",
            description: "NeoAra는 NewsGroup을 연동하고자 한 NNTP 기반의 아라입니다.\n      KAIST 구성원만을 위한 NewsGroup 뿐만 아니라 KAIST 주변의 한국 내 인터넷 사용자\n      모두를 위한 NewsGroup 으로서의 역할도 하려고 하였습니다",
            members: {
                SO: ["kaien:박상진", "godslord:권용철", "algepher:변창환", "neosado:김영준", "tapung:채주병"]
            }
        }, {
            name: "NeoAra & WebAra",
            period: "2006~2008",
            launched: "2006",
            description: "NeoAra & WebAra는 웹과의 연동이 시작된 아라입니다.\n      덕분에 Telnet, NNTP 뿐만 아니라 Web 으로도 아라를 이용이 가능해졌습니다.\n      또한 파일 첨부기능이 추가되어 학우들이 더 다양한 방식으로 아라를 이용할 수 있었습니다.",
            members: {
                SO: ["airlover:김유승", "pcpenpal:박용수", "softdie:김동주"]
            }
        }, {
            name: "Arara 1세대",
            period: "2008~2010",
            launched: "2008",
            description: "Arara 1세대는 유지보수가 어려워진 NeoAra & WebAra를 대체하기 위해 출범하였으며,\n      이종 언어가 자유로이 쓰이는 확장가능 구조로 개발되었습니다.\n      Python을 기반으로 백엔드에서는 SQLAlchemy, 미들웨어로는 Thrift RPC,\n      프론트엔드에서는 Django Template Engine 을 사용하였습니다.",
            members: {
                DV: ["serialx:홍성진", "pipocket:서우석", "ssaljalu:조준희", "breadfish:구성모", "jcob:조지혁", "peremen:박신조", "combacsa:변규홍"]
            }
        }, {
            name: "Arara 2세대",
            period: "2010~2020",
            launched: "2011",
            description: "Arara 2세대는 2010년부터 2020년 10월까지 학우들이 가장 오랫동안 이용한 아라입니다.\n      2011년 리뉴얼된 당시 동시접속자수 200명, 하루 평균 접속자수가 7000명으로 KAIST 학내\n      공식 커뮤니티로서 아라의 위상을 확인할 수 있었습니다.\n      기존 ARAra 엔진 디자인을 새롭게 하고, 동시에 XpressEngine 기반 아라를 개발하려는\n      노력이 있었습니다. 또한 RSS 등 사용자들이 필요로 한 기능이 구현되었습니다.",
            members: {
                PM: ["combacsa:변규홍"],
                DV: ["mikkang:김문범", "reniowood:김진혁", "harry:이대근", "jeanclaire:이현진", "ssaljalu:조준희", "anna418:조유정", "richking:김창하", "xhark:김재홍", "leopine:이가영", "snogar:차동훈", "imai:배성경", "r4t5y6:임규리", "kuss:안재만", "hodduc:이준성", "leeopop:이근홍"]
            }
        }, {
            name: "모바일 아라",
            period: "2011~2020",
            launched: "2012",
            description: "모바일 아라는 아라를 모바일로 이용하는 수요가 늘면서,\n      그에 맞게 디자인을 개선시키고 Arara의 엔진 성능을 개선하고자한 프로젝트입니다.",
            members: {
                PM: ["hodduc:이준성"],
                DV: ["richking:김창하", "combasa:변규홍", "grandmarnier:차준호", "bbashong:최낙현", "panda:조민지", "elaborate:안병욱", "penguin:민서영", "pocari:이경태", "zzongaly:정진근"]
            }
        }, {
            name: "아라리",
            period: "2012~2013",
            members: {
                PM: ["zzongaly:정진근"],
                DV: ["bbashong:최낙현", "undead:이창원", "boolgom:심규민", "rodumani:정창제", "panda:조민지", "naldo:박지혁", "yasik:박중언", "apple:김영석", "veritas:정진훈", "jjus:김지현", "alice:문슬기", "penguin:민서영"]
            }
        }, {
            name: "아라2",
            period: "2013~2014",
            members: {
                PM: ["serialx:홍성진"],
                DV: ["hodduc:이준성", "raon:김강인", "bbashong:최낙현", "richking:김창하"]
            }
        }, {
            name: "아라플러스",
            period: "2015~2016",
            description: "아라플러스는 KAIST 학생 사회에서 ARA를 다시 활성화하기 위해, 커뮤니티 활동을 즐길 수\n      있는 풍부한 기능들을 새로운 UI와 함께 제공하고자 했던 프로젝트입니다. 사용자들이 특정\n      주제에 대해 채팅을 나눌 수 있는 '불판', 동아리나 자치단체, 소모임을 위한 '그룹게시판',\n      익명 글작성, 포인트 제도 등 재미있는 기능들이 기획되고 개발되었습니다.",
            members: {
                PM: ["story:김동화", "kyeome:김태겸"],
                DV: ["kanon:김민수", "apple:김영석", "zealot:한승현", "undead:이창원", "mandu:황태현", "samjo:조성원", "suckzoo:홍석주", "luan:이상국", "george:조형준", "jara:이문영"]
            }
        }, {
            name: "뉴아라",
            period: "2017~On-going",
            launched: "2020",
            description: "2020년 11월 출범한 뉴아라는 '가장 정확한 정보를 가장 신속하게'라는 슬로건으로 10년간\n      이용되던 Arara 를 새롭게 리뉴얼한 프로젝트입니다. 뉴아라에서는 카이스트 포탈공지를\n      아라에서도 제공하기 시작했고, 기존 ARA의 게시물과 댓글을 모두 이전시켰음에도 빠른 속도를\n      유지했으며, elasticsearch를 도입해 발전된 검색기능을 선보였습니다.\n      또한 아라의 아이덴티티가 잘 드러나도록 홈페이지 디자인을 개선하였습니다.",
            members: {
                PM: [["yuwol:황인준", 2022], ["jessie:윤지수", 2021], ["victory:김주연", 2020], ["leo:정진우", 2019], ["yujingaya:김유진", 2018], ["swan:지수환", 2018], ["raon:김강인", 2017]],
                DV: ["ina:송인화", "ddungiii:김기영", "duncan:이동재", "panya:김지연", "ivy:이융희", "jungnoh:노정훈", "water:김윤수", "triangle:주예준", "hanski:한석휘", "idev:이재현", "doolly:김제윤", "nenw:김요한", "fi:김도현", "james:문재호", "busan:안재웅", "kidevelop:함종현", "holymolly:김태원", "gunwoo:김건우", "todo:김동관", "his:황인승", "rongrong:이승민", "leesia:강현우", "seol:설윤아", "youns:최윤서", "appleseed:강찬규"],
                DS: ["cheddar:최다은", "stitch:이채영", "zero:임현정", "luny:김나영"]
            }
        }]
          , Cr = {
            name: "Makers",
            components: {
                MakersCard: gr,
                TheLayout: pn
            },
            data: function() {
                return {
                    projects: kr,
                    positions: ["SO", "PM", "DS", "DV"],
                    selected: 9
                }
            },
            beforeCreate: function() {
                document.body.style.background = "#fafafa"
            },
            methods: {
                projectName: function(t) {
                    var e = t.launched
                      , n = t.name;
                    return e ? "🚀 ".concat(n) : n
                },
                memberName: function(t) {
                    return Array.isArray(t) && (t = t[0]),
                    t.split(":")[1]
                },
                memberNickname: function(t) {
                    return Array.isArray(t) && (t = t[0]),
                    t.split(":")[0]
                },
                memberPosition: function(t, e) {
                    return Array.isArray(t) ? "".concat(t[1], " ").concat(yr[e]) : yr[e]
                },
                projectClicked: function(t) {
                    this.selected = t
                }
            }
        }
          , wr = Cr
          , xr = (n("254e"),
        Object(y["a"])(wr, pr, mr, !1, null, "ed2ebf90", null))
          , Ar = xr.exports
          , Or = function() {
            var t = this
              , e = t.$createElement
              , n = t._self._c || e;
            return n("div", [n("div", {
                staticClass: "not-found-container"
            }, [n("div", {
                staticClass: "not-found-404"
            }, [t._v(" 410 ")]), n("div", {
                staticClass: "deleted-text"
            }, [t._v(" " + t._s(t.$t("deleted-post")) + " ")]), n("router-link", {
                attrs: {
                    to: {
                        name: "home"
                    }
                }
            }, [n("div", {
                staticClass: "not-found-go-to-home"
            }, [t._v(" " + t._s(t.$t("go-home")) + " ")])])], 1)])
        }
          , Sr = []
          , $r = {
            name: "Deleted",
            beforeRouteEnter: function(t, e, n) {
                n((function(t) {
                    document.title = t.$t("document-title")
                }
                ))
            }
        }
          , jr = $r
          , Tr = (n("e791"),
        n("edec"))
          , Er = Object(y["a"])(jr, Or, Sr, !1, null, null, null);
        "function" === typeof Tr["default"] && Object(Tr["default"])(Er);
        var Ir = Er.exports
          , Pr = [{
            path: "/board/:boardSlug?",
            name: "board",
            component: Oa,
            beforeEnter: bn
        }, {
            path: "/user/:username?",
            name: "user",
            component: Ia,
            beforeEnter: bn
        }, {
            path: "/post/:postId",
            name: "post",
            component: xo,
            props: !0,
            beforeEnter: function() {
                var t = Object(u["a"])(p.a.mark((function t(e, n, a) {
                    return p.a.wrap((function(t) {
                        while (1)
                            switch (t.prev = t.next) {
                            case 0:
                                if ("notifications" !== n.name || !e.params.notiId) {
                                    t.next = 3;
                                    break
                                }
                                return t.next = 3,
                                Rt(e.params.notiId);
                            case 3:
                                return t.next = 5,
                                bn(e, n, a);
                            case 5:
                            case "end":
                                return t.stop()
                            }
                    }
                    ), t)
                }
                )));
                function e(e, n, a) {
                    return t.apply(this, arguments)
                }
                return e
            }()
        }, {
            path: "/write/:postId?",
            name: "write",
            component: Fo,
            props: !0,
            beforeEnter: bn
        }, {
            path: "/notifications",
            name: "notifications",
            component: ms,
            beforeEnter: bn
        }, {
            path: "/myinfo",
            name: "my-info",
            component: Cs,
            beforeEnter: bn
        }, {
            path: "/404",
            name: "not-found",
            component: ir
        }, {
            path: "/410",
            name: "deleted",
            component: Ir
        }, {
            path: "/",
            name: "home",
            component: Ys,
            beforeEnter: bn
        }, {
            path: "/landing",
            name: "landing",
            component: dr
        }, {
            path: "/makers",
            name: "makers",
            component: Ar,
            beforeEnter: bn
        }];
        a["a"].use(D["a"]),
        a["a"].use(q["a"]);
        var Nr = new D["a"]({
            mode: "history",
            routes: [].concat(Object(L["a"])(vn), Object(L["a"])(Pr), [{
                path: "*",
                name: "not-found",
                component: ir
            }]),
            scrollBehavior: function(t, e, n) {
                return t.hash ? {
                    selector: t.hash
                } : n || {
                    x: 0,
                    y: 0
                }
            }
        })
          , Rr = n("9483");
        Object(Rr["a"])("".concat("/", "service-worker.js"), {
            ready: function() {
                console.log("App is being served from cache by a service worker.\nFor more details, visit https://goo.gl/AFskqB")
            },
            registered: function() {
                console.log("Service worker has been registered.")
            },
            cached: function() {
                console.log("Content has been cached for offline use.")
            },
            updatefound: function() {
                console.log("New content is downloading.")
            },
            updated: function() {
                console.log("New content is available; please refresh.")
            },
            offline: function() {
                console.log("No internet connection found. App is running in offline mode.")
            },
            error: function(t) {
                console.error("Error during service worker registration:", t)
            }
        }),
        a["a"].prototype.$http = lt,
        new a["a"]({
            router: Nr,
            store: Xt,
            i18n: b,
            render: function(t) {
                return t(B)
            }
        }).$mount("#app")
    },
    cd8f: function(t, e, n) {},
    cdb3: function(t, e, n) {
        "use strict";
        n("c58b")
    },
    d091: function(t, e, n) {
        "use strict";
        n("edfc")
    },
    d12e: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"img-invalid-title":"이미지를 불러오는데 실패했습니다. 포탈 공지 글인 경우 위 링크를 클릭해 주세요.","img-invalid-subtitle":"(로그인 후 포탈 메인 페이지가 보인다면 링크를 다시 클릭해 주세요)"},"en":{"img-invalid-title":"Failed to load image. If it is a portal notice, please click the link above.","img-invalid-subtitle":"If you see the portal main page after logging in, click the link again."}}'),
            delete t.options._Ctor
        }
    },
    d15b: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"comments":"댓글","no-comment":"댓글이 없습니다."},"en":{"comments":"Comments","no-comment":"No comment."}}'),
            delete t.options._Ctor
        }
    },
    d22a: function(t, e, n) {
        "use strict";
        var a = n("038d")
          , i = n.n(a);
        e["default"] = i.a
    },
    d29e: function(t, e, n) {
        "use strict";
        n("1704")
    },
    d2d3: function(t, e, n) {
        "use strict";
        n("3da6")
    },
    d4fc: function(t, e, n) {
        "use strict";
        n("f52a")
    },
    d532: function(t, e, n) {
        "use strict";
        n("56a9")
    },
    d607: function(t, e, n) {},
    d803: function(t, e, n) {},
    da4e: function(t, e, n) {
        "use strict";
        var a = n("b7f6")
          , i = n.n(a);
        e["default"] = i.a
    },
    df97: function(t, e, n) {
        "use strict";
        var a = n("d15b")
          , i = n.n(a);
        e["default"] = i.a
    },
    e0d3: function(t, e, n) {
        "use strict";
        var a = n("aa47")
          , i = n.n(a);
        e["default"] = i.a
    },
    e1eb: function(t, e, n) {},
    e375: function(t, e, n) {},
    e791: function(t, e, n) {
        "use strict";
        n("70b9")
    },
    e792: function(t, e, n) {
        "use strict";
        var a = n("d12e")
          , i = n.n(a);
        e["default"] = i.a
    },
    e8c3: function(t, e, n) {
        "use strict";
        n("7be2")
    },
    ebdf: function(t, e, n) {},
    ed05: function(t, e, n) {
        "use strict";
        var a = n("c1a1")
          , i = n.n(a);
        e["default"] = i.a
    },
    edec: function(t, e, n) {
        "use strict";
        var a = n("a8cd")
          , i = n.n(a);
        e["default"] = i.a
    },
    edfc: function(t, e, n) {},
    f06d: function(t, e, n) {
        "use strict";
        var a = n("84d7")
          , i = n.n(a);
        e["default"] = i.a
    },
    f0ef: function(t, e, n) {
        var a = {
            "./LogoGSA.png": "a9df",
            "./LogoGSDC.png": "b437",
            "./LogoKAIST.png": "aba5",
            "./LogoKCOOP.png": "9e20",
            "./LogoNSA.png": "1f91",
            "./LogoSA.png": "b460",
            "./LogoSWF.png": "1d69",
            "./LogoUA.png": "7bff"
        };
        function i(t) {
            var e = o(t);
            return n(e)
        }
        function o(t) {
            if (!n.o(a, t)) {
                var e = new Error("Cannot find module '" + t + "'");
                throw e.code = "MODULE_NOT_FOUND",
                e
            }
            return a[t]
        }
        i.keys = function() {
            return Object.keys(a)
        }
        ,
        i.resolve = o,
        t.exports = i,
        i.id = "f0ef"
    },
    f41e: function(t, e, n) {},
    f424: function(t, e, n) {},
    f52a: function(t, e, n) {},
    f87e: function(t, e, n) {
        "use strict";
        n("3629")
    },
    f9dd: function(t, e) {
        t.exports = function(t) {
            t.options.__i18n = t.options.__i18n || [],
            t.options.__i18n.push('{"ko":{"archive":"담아두기","unarchive":"담기 취소","edit":"수정","delete":"삭제","report":"신고","comments":"댓글","views":"조회수","previous":"이전글","next":"다음글","list":"목록","block":"사용자 차단","unblock":"사용자 차단해제","confirm-delete":"정말로 삭제하시겠습니까?","all":"전체보기","prev-page":"이전 페이지","recent-board":"최근 본 글","archive-board":"담아둔 글","status":{"polling":"달성전","preparing":"답변 준비중","answered":"답변 완료"}},"en":{"archive":"Bookmark","unarchive":"Delete Bookmark","edit":"Edit","delete":"Delete","report":"Report","comments":"Comments","views":"View","previous":"Previous","next":"Next","list":"Posts","block":"Block User","unblock":"Unblock User","confirm-delete":"Are you really want to delete this post?","all":"All","prev-page":"Previous Page","recent-board":"Recent Articles","archive-board":"Bookmarks","status":{"polling":"Polling","preparing":"Preparing","answered":"Answered"}}}'),
            delete t.options._Ctor
        }
    },
    faeb: function(t, e, n) {
        t.exports = n.p + "img/SparcsLogo.6562eaba.svg"
    },
    fbee: function(t, e, n) {
        t.exports = n.p + "img/ServiceAra.6b3ab0a9.svg"
    },
    fc71: function(t, e, n) {
        "use strict";
        n("4213")
    },
    fe65: function(t, e, n) {
        "use strict";
        var a = n("bc93")
          , i = n.n(a);
        e["default"] = i.a
    }
});
